defmodule Osdi.Person do
  use Ecto.Schema

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
    |> Ecto.Changeset.cast(params, [:given_name, :family_name])
    |> Ecto.Changeset.cast_embed(:email_addresses)
    |> Ecto.Changeset.validate_required([:given_name, :family_name])
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
    |> Ecto.Changeset.cast(params,
        [:given_name, :family_name, :honorific_prefix, :honorific_suffix,
         :gender, :birthdate, :languages_spoken, :party_identification])
    |> Ecto.Changeset.cast_embed(:email_addresses)
    |> Ecto.Changeset.cast_embed(:postal_addresses)
    |> Ecto.Changeset.cast_embed(:phone_numbers)
    |> Ecto.Changeset.cast_embed(:profiles)
    |> Ecto.Changeset.cast_assoc(:taggings)
    |> Ecto.Changeset.validate_required([:given_name, :family_name])
  end
end
