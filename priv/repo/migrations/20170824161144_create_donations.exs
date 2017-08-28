defmodule Osdi.Repo.Migrations.CreateDonations do
  use Ecto.Migration

  def change do
    create table(:donations) do
      add :origin_system, :string
      add :action_date, :utc_datetime
      add :amount, :float
      add :recipients, {:array, :map}, default: []
      add :payment, :map
      add :voided, :boolean
      add :voided_date, :utc_datetime
      add :url, :string
      add :referrer_data, :map
      timestamps()
    end
  end
end
