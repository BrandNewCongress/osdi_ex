defmodule Osdi.Person do
  use Ecto.Schema

  schema "people" do
    field :given_name, :string
    field :family_name, :string
    field :additional_name, :string
    field :honorific_prefix, :string
    field :honorific_suffix, :string
    field :gender, :string
    field :birthdate, :map
    field :languages_spoken, {:array, :string}
    field :party_identification, :string
    field :parties, {:array, :map}
    field :postal_addresses, {:array, :map}
    field :email_addresses, {:array, :map}
    field :phone_numbers, {:array, :map}
    field :profiles, {:array, :map}

    has_many :donations, Osdi.Donation
    has_many :attendances, Osdi.Attendance

    timestamps()
  end

  def signup_email(person, params \\ %{}) do
    params = format_email(person, params)

    person
    |> Ecto.Changeset.cast(params, [:given_name, :family_name, :email_addresses])
    |> Ecto.Changeset.validate_required([:given_name, :family_name, :email_addresses])
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
      |> Enum.filter(fn %{"address" => address} -> address != email end)
      |> Enum.concat([%{primary: true, address: email, status: "subscribed"}])

    params
    |> Map.delete(:email)
    |> Map.put(:email_addresses, new_eas)
  end
end
