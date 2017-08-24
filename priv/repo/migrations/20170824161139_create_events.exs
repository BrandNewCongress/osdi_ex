defmodule Osdi.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :name, :string
      add :title, :string
      add :description, :string
      add :summary, :string
      add :browser_url, :string
      add :type, :string
      add :location, :map
      add :featured_image_url, :string
      add :start_date, :utc_datetime
      add :end_date, :utc_datetime
      add :calendar, :string
      timestamps()
    end
  end
end
