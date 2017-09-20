defmodule Osdi.Repo.Migrations.EditHistory do
  use Ecto.Migration

  def change do
    create table(:admin_history) do
      add :actor, :string
      add :edit, :map
      add :event_id, references(:events)
      add :person_id, references(:events)

      timestamps()
    end
  end
end
