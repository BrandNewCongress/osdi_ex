defmodule Osdi.Repo.Migrations.CreateTags do
  use Ecto.Migration

  def change do
    create table(:tags) do
      add :name, :string, unique: true
      add :origin_system, :string
      add :description, :string

      timestamps()
    end

    create index(:tags, [:name], unique: true)
  end
end
