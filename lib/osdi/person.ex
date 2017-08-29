defmodule Osdi.Person do
  use Ecto.Schema
  import Ecto.Changeset
  alias Osdi.{Repo}
  import Ecto.Query

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
    embeds_many :postal_addresses, Osdi.Address
    embeds_many :email_addresses, Osdi.EmailAddress
    embeds_many :phone_numbers, Osdi.PhoneNumber
    embeds_many :profiles, Osdi.Profile

    has_many :donations, Osdi.Donation
    has_many :attendances, Osdi.Attendance
    has_many :taggings, Osdi.Tagging

    timestamps()
  end

  def signup_email(person, params \\ %{}) do
    params = format_email(person, params)

    person
    |> cast(params, [:given_name, :family_name])
    |> cast_embed(:email_addresses)
    |> validate_required([:given_name, :family_name])
  end

  defp format_email(%{email_addresses: nil}, params = %{email: email}) do
    new_eas = [%{primary: true, address: email, status: "subscribed"}]

    params
    |> Map.delete(:email)
    |> Map.put(:email_addresses, new_eas)
  end

  defp format_email(%{email_addresses: eas}, params = %{email: email}) do
    new_eas =
      eas
      |> Enum.filter(fn %{address: address} -> address != email end)
      |> Enum.map(&Map.from_struct/1)
      |> Enum.concat([%{primary: true, address: email, status: "subscribed"}])

    params
    |> Map.delete(:email)
    |> Map.put(:email_addresses, new_eas)
  end

  def changeset(person, params \\ %{}) do
    person
    |> cast(params,
        [:given_name, :family_name, :honorific_prefix, :honorific_suffix,
         :gender, :birthdate, :languages_spoken, :party_identification])
    |> cast_embed(:email_addresses)
    |> cast_embed(:postal_addresses)
    |> cast_embed(:phone_numbers)
    |> cast_embed(:profiles)
    |> cast_assoc(:taggings)
    |> validate_required([:given_name, :family_name])
  end

  def match(person, params \\ %{}) do
    Repo.one from p in Osdi.Person,
      where: p.email_addresses
  end

  def add_tags(person = %Osdi.Person{id: id}, tags) do
    tagging_structs =
      tags
      |> Enum.map(&Osdi.Tag.ensure/1)
      |> Enum.map(&(%{person_id: person.id, tag_id: &1.id, item_type: "person",
                      inserted_at: Ecto.DateTime.utc(), updated_at: Ecto.DateTime.utc()}))

    {_n, taggings} = Repo.insert_all(Osdi.Tagging, tagging_structs, returning: true)
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
