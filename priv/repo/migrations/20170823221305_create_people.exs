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
      add :birthdate, :map
      add :languages_spoken, {:array, :string}
      add :party_identification, :string
      add :parties, {:array, :map}
      add :postal_addresses, {:array, :map}
      add :email_addresses, {:array, :map}
      add :phone_numbers, {:array, :map}
      add :profiles, {:array, :map}
      timestamps()
    end
  end
end
