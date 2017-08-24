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
  end
end
