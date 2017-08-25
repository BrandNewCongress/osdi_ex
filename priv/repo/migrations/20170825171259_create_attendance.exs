defmodule Osdi.Repo.Migrations.CreateAttendance do
  use Ecto.Migration

  def change do
    create table(:attendances) do
      add :origin_system, :string
      add :action_date, :utc_datetime
      add :status, :string
      add :attended, :boolean
      add :referrer_data, :map

      timestamps()
    end
  end
end
