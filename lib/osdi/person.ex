defmodule Osdi.Person do
  use Ecto.Schema
  import Ecto.Changeset
  alias Osdi.{Repo, PhoneNumber, EmailAddress}
  import Ecto.Query

  @base_attrs ~w(
    given_name family_name honorific_prefix honorific_suffix
    gender birthdate languages_spoken party_identification
  )a

  @associations ~w(phone_numbers email_addresses postal_addresses tags)a

  schema "people" do
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

  def changeset(person, params \\ %{}) do
    person
    |> cast(params, @base_attrs)
    |> cast_embed(:profiles)
    |> put_assoc(:tags, params.tags)
    |> put_assoc(:email_addresses, params.email_addresses)
    |> put_assoc(:phone_numbers, params.phone_numbers)
    |> put_assoc(:postal_addresses, params.postal_addresses)
    |> validate_required([:given_name, :family_name])
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
      |> (fn numbers -> from pn in PhoneNumber, where: pn.number in ^numbers end).()
      |> Repo.one()
      |> Repo.preload(:people)
      |> people_ids()

    email_possibilities =
      person
      |> get_emails()
      |> (fn emails -> from em in EmailAddress, where: em.address in ^emails end).()
      |> Repo.one()
      |> Repo.preload(:people)
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
      nil -> Repo.insert!(person)

      %Osdi.Person{id: id} ->
        existing =
          (from p in Osdi.Person, where: p.id == ^id)
          |> Repo.one()
          |> Repo.preload(@associations)

        new_emails =
          (person[:email_addresses] || [])
          |> Enum.map(&EmailAddress.get_or_insert/1)
          |> Enum.concat(existing.email_addresses)
          |> Enum.uniq_by(&(&1.address))

        new_phones =
          (person[:phone_numbers] || [])
          |> Enum.map(&PhoneNumber.get_or_insert/1)
          |> Enum.concat(existing.phone_numbers)
          |> Enum.uniq_by(&(&1.number))

        params =
          existing
          |> Map.put(:email_addresses, new_emails)
          |> Map.put(:phone_numbers, new_phones)
          |> Map.from_struct()
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
end
