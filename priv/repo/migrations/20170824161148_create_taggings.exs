defmodule Osdi.Repo.Migrations.CreateTaggings do
  use Ecto.Migration

  def change do
    create table(:taggings) do
      add :name, :string
      add :origin_system, :string
      add :description, :string
      timestamps()
    end
  end
end
