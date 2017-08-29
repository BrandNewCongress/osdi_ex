defmodule Osdi.Repo.Migrations.CreateTaggings do
  use Ecto.Migration

  def change do
    create table(:taggings) do
      add :origin_system, :string
      add :item_type, :string

      timestamps()
    end
  end
end
