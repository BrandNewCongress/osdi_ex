defmodule Osdi.Person do
  use Ecto.Schema
  import Ecto.Changeset
  alias Osdi.{Repo, PhoneNumber, EmailAddress, Address, Tag}
  import Ecto.Query

  @base_attrs ~w(
    identifiers given_name family_name honorific_prefix honorific_suffix
    gender birthdate languages_spoken party_identification
  )a

  @associations ~w(phone_numbers email_addresses postal_addresses tags)a

  @derive {Poison.Encoder, only: @base_attrs ++ @associations}
  schema "people" do
    field :identifiers, {:array, :string}
    field :given_name, :string
    field :family_name, :string
    field :additional_name, :string
    field :honorific_prefix, :string
    field :honorific_suffix, :string
    field :gender, :string
    field :birthdate, :date
    field :languages_spoken, {:array, :string}
    field :party_identification, :string

    embeds_many :parties, Osdi.Party
    embeds_many :profiles, Osdi.Profile

    has_many :donations, Osdi.Donation
    has_many :attendances, Osdi.Attendance

    many_to_many :phone_numbers, Osdi.PhoneNumber, join_through: "people_phones", on_replace: :delete
    many_to_many :email_addresses, Osdi.EmailAddress, join_through: "people_emails", on_replace: :delete
    many_to_many :postal_addresses, Osdi.Address, join_through: "people_addresses", on_replace: :delete
    many_to_many :tags, Osdi.Tag, join_through: Osdi.Tagging, on_replace: :delete

    timestamps()
  end

  defimpl Poison.Encoder, for: Osdi.Person do
    def encode(person, options) do
      person
      |> Map.from_struct()
      |> Enum.reject(fn {_key, value} -> not Ecto.assoc_loaded?(value) end)
      |> Map.new()
      |> Map.drop([:__meta__])
      |> Poison.Encoder.Map.encode(options)
    end
  end

  def changeset(person, params \\ %{}) do
    params = Enum.reduce(
      [{:email_address, EmailAddress}, {:phone_numbers, PhoneNumber},
       {:postal_addresses, Address}],
      params,
      &association_reduce/2)

    person
    |> cast(params, @base_attrs)
    |> cast_embed(:profiles)
    |> x_assoc(:email_addresses, params.email_addresses)
    |> x_assoc(:phone_numbers, params.phone_numbers)
    |> x_assoc(:postal_addresses, params.postal_addresses)
  end

  defp association_reduce({assoc, model}, params) do
    new_els = case params[assoc] do
      nil -> params[assoc]
      [%model{} | _] -> params[assoc] |> Enum.map(&model.get_or_insert/1)
      [%{} | _] -> params[assoc] |> Enum.map(&model.get_or_insert/1)
      [] -> params[assoc]
    end

    Map.put(params, assoc, new_els)
  end

  defp x_assoc(changeset, key, nil) do
    changeset
  end

  defp x_assoc(changeset, key, els) do
    changeset
    |> put_assoc(key, els)
  end

  def match(person = %Osdi.Person{}) do
    person
    |> Map.from_struct()
    |> match()
  end

  def match(person) do
    phone_possibilities =
      person
      |> get_numbers()
      |> Enum.reject(&(&1 == ""))
      |> (fn numbers -> from pn in PhoneNumber, where: pn.number in ^numbers end).()
      |> Repo.all()
      |> Repo.preload(:people)
      |> Enum.to_list()
      |> people_ids()

    email_possibilities =
      person
      |> get_emails()
      |> Enum.reject(&(&1 == ""))
      |> (fn emails -> from em in EmailAddress, where: em.address in ^emails end).()
      |> Repo.all()
      |> Repo.preload(:people)
      |> Enum.to_list()
      |> people_ids()

    all_ids = phone_possibilities ++ email_possibilities

    chosen =
      all_ids
      |> Enum.into(MapSet.new())
      |> Enum.map(fn id -> {id, Enum.count(all_ids, &(&1 == id))} end)
      |> Enum.sort(fn ({_, c1}, {_, c2}) -> c1 >= c2 end)
      |> List.first()

    case chosen do
      {id, _count} ->
        (from p in Osdi.Person, where: p.id == ^id)
        |> Repo.one()
        |> Repo.preload([:phone_numbers, :email_addresses])

      nil -> nil
    end
  end

  defp people_ids([]), do: []
  defp people_ids(people_list = [%{} | _]), do:
    people_list
    |> Enum.flat_map(fn %{people: people} -> people |> Enum.map(&(&1.id)) end)

  defp people_ids(%{people: people}), do: people |> Enum.map(&(&1.id))
  defp people_ids(nil), do: []

  defp get_numbers(%{phone_number: number}), do: [number]
  defp get_numbers(%{phone_numbers: number_structs}), do: number_structs |> Enum.map(&(&1.number))
  defp get_emails(%{email_address: address}), do: [address]
  defp get_emails(%{email_addresses: address_structs}), do: address_structs |> Enum.map(&(&1.address))

  @doc """
  Matches person and joins email addresses and phone numbers
  Overwrites name and all other simple person fields
  """
  def push(person = %Osdi.Person{}) do
    person
    |> Map.from_struct()
    |> push()
  end

  def push(person) do
    case match(person) do
      # No match found
      nil ->
        as_map = case person do
          %{__struct__: _} -> person |> Map.from_struct()
          %{} -> person
        end

        %Osdi.Person{}
        |> changeset(as_map)
        |> Repo.insert!()

      # Match chosen
      %Osdi.Person{id: id} ->
        existing =
          (from p in Osdi.Person, where: p.id == ^id)
          |> Repo.one()
          |> Repo.preload(@associations)

        params =
          [{:email_addresses, EmailAddress, &(&1.address)},
           {:phone_numbers, PhoneNumber, &(&1.number)},
           {:tags, Tag, &(&1.name)}]
          |> Enum.map(generate_combiner(person, existing))
          |> Enum.reduce(existing, fn ({key, val}, acc) -> Map.put(acc, key, val) end)
          |> Map.put(:identifiers, combine_identifiers(person[:identifiers], existing.identifiers))
          |> Map.take(@base_attrs ++ @associations)

        %{id: id} =
          existing
          |> changeset(params)
          |> Repo.update!()

        (from p in Osdi.Person, where: p.id == ^id)
        |> Repo.one()
        |> Repo.preload([:phone_numbers, :email_addresses])
    end
  end

  defp generate_combiner(person, existing) do
    fn {key, module, uniquer} ->
      combined =
        (person[key] || [])
        |> Enum.map(&module.get_or_insert/1)
        |> Enum.concat(Map.get(existing, key))
        |> Enum.uniq_by(uniquer)

      # IO.inspect key
      # IO.inspect combined

      {key, combined}
    end
  end

  defp combine_identifiers(list_a, list_b) do
    (list_a || [])
    |> Enum.concat(list_b || [])
    |> Enum.into(MapSet.new())
    |> Enum.to_list()
  end

  defp ensure_tags(person = %Osdi.Person{tags: current_tags}) when is_list(current_tags), do: person
  defp ensure_tags(_person = %Osdi.Person{id: id}), do:
    Osdi.Person
    |> Repo.get(id)
    |> Repo.preload(:tags)

  def add_tags(person_maybe_tags, tags) do
    person = %Osdi.Person{tags: current_tags} = ensure_tags(person_maybe_tags)
    current_tagstrings = current_tags |> Enum.map(&(&1.name))

    records =
      tags
      |> Enum.concat(current_tagstrings)
      |> Tag.get_or_insert_all()

    person
    |> change(tags: records)
    |> Repo.update!()
  end

  def remove_tags(person_maybe_tags, tags) do
    person = %Osdi.Person{tags: current_tags} = ensure_tags(person_maybe_tags)

    records =
      current_tags
      |> Enum.map(&(&1.name))
      |> Enum.reject(fn tag -> Enum.member?(tags, tag) end)
      |> Tag.get_or_insert_all()

    person
    |> change(tags: records)
    |> Repo.update!()
  end

end
