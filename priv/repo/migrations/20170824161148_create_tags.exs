defmodule Osdi.Repo.Migrations.CreateTags do
  use Ecto.Migration

  def change do
    create table(:tags) do
      add :item_type, :string
      add :origin_system, :string
      timestamps()
    end
  end
end
