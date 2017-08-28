defmodule Osdi.Repo.Migrations.CreatePeople do
  use Ecto.Migration

  def change do
    create table(:people) do
      add :given_name, :string
      add :family_name, :string
      add :additional_name, :string
      add :honorific_prefix, :string
      add :honorific_suffix, :string
      add :gender, :string
      add :birthdate, :date
      add :languages_spoken, {:array, :string}
      add :party_identification, :string
      add :parties, {:array, :map}, default: []
      add :postal_addresses, {:array, :map}, default: []
      add :email_addresses, {:array, :map}, default: []
      add :phone_numbers, {:array, :map}, default: []
      add :profiles, {:array, :map}, default: []
      timestamps()
    end
  end
end
