defmodule Osdi.Person do
  use Ecto.Schema
  import Ecto.Changeset
  alias Osdi.{Repo, PhoneNumber, EmailAddress}
  import Ecto.Query

  @base_attrs ~w(
    given_name family_name honorific_prefix honorific_suffix
    gender birthdate languages_spoken party_identification
  )a

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
    |> cast_assoc(:tags)
    |> cast_assoc(:email_addresses)
    |> cast_assoc(:phone_numbers)
    |> cast_assoc(:postal_addresses)
    |> validate_required([:given_name, :family_name])
  end

  def match(person, params \\ %{}) do
    phone_result = case person[:phone_number] do
      nil -> []
      number ->
        (from pn in PhoneNumber, where: pn.number == ^number)
        |> Repo.one()
        |> Repo.preload(:people)
    end

    phone_possibilities = case phone_result do
      %{people: people} -> people |> Enum.map(&(&1.id))
      _ -> []
    end

    email_result = case person[:email_address] do
      nil -> []
      address ->
        (from em in EmailAddress, where: em.address == ^address)
        |> Repo.one()
        |> Repo.preload(:people)
    end

    email_possibilities = case email_result do
      %{people: people} -> people |> Enum.map(&(&1.id))
      _ -> []
    end

    all_ids = phone_possibilities ++ email_possibilities

    chosen =
      all_ids
      |> Enum.into(MapSet.new())
      |> Enum.map(fn id -> {id, Enum.count(all_ids, &(&1 == id))} end)
      |> Enum.concat([{10,3}])
      |> Enum.sort(fn ({_, c1}, {_, c2}) -> c1 >= c2 end)
      |> List.first()

    case chosen do
      {_count, id} -> Repo.get(Osdi.Person, id)
      nil -> nil
    end
  end
end
