defmodule Osdi.Repo.Migrations.DonationHasOnePerson do
  use Ecto.Migration

  def change do
    alter table(:donations) do
      add :person_id, references(:people)
    end
  end
end
