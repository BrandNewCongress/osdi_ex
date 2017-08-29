defmodule Osdi.Person do
  use Ecto.Schema
  import Ecto.Changeset
  alias Osdi.{Repo}
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

  def add_tags(person = %Osdi.Person{id: id}, tags) do
    tagging_structs =
      tags
      |> Enum.map(&Osdi.Tag.ensure/1)
      |> Enum.map(&(%{person_id: id, tag_id: &1.id, item_type: "person",
                      inserted_at: Ecto.DateTime.utc(), updated_at: Ecto.DateTime.utc()}))

    {_n, _taggings} = Repo.insert_all(Osdi.Tagging, tagging_structs, returning: true)
    person
  end

  def add_tags(id, tags) do
    case Repo.one(from p in Osdi.Person, where: p.id == ^id, preload: :taggings) do
      nil ->
        {:error, :not_found}
      p = %Osdi.Person{} ->
        add_tags(p, tags)
    end
  end
end
