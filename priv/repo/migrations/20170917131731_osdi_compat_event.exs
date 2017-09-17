defmodule Osdi.Repo.Migrations.OsdiCompatEvent do
  use Ecto.Migration

  def change do
    alter table(:events) do
      add :instructions, :text
    end

    rename table(:events), :host, [to: :contact]
  end
end
