defmodule Osdi.Repo.Migrations.TagTaggingAssocs do
  use Ecto.Migration

  def change do
    alter table(:taggings) do
      add :tag_id, references(:tags)
      add :person_id, references(:people)
    end
  end
end
