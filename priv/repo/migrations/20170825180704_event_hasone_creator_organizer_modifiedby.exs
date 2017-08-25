defmodule Osdi.Repo.Migrations.EventHasoneCreatorOrganizerModifiedby do
  use Ecto.Migration

  def change do
    alter table(:donations) do
      add :creator, references(:people)
      add :organizer, references(:people)
      add :modified_by, references(:people)
    end
  end
end
