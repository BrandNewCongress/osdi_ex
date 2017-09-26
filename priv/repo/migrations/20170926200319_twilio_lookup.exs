defmodule Osdi.Repo.Migrations.TwilioLookup do
  use Ecto.Migration

  def change do
    alter table(:phone_numbers) do
      add :twilio_lookup_result, :map
    end
  end
end
