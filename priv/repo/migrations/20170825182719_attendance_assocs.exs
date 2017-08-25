defmodule Osdi.Repo.Migrations.AttendanceAssocs do
  use Ecto.Migration

  def change do
    alter table(:attendances) do
      add :person_id, references(:people)
      add :event_id, references(:events)
    end
  end
end
