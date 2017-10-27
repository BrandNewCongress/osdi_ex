defmodule Osdi.Repo.Migrations.AddFundraisingPage do
  use Ecto.Migration

  def change do
    create table(:fundraising_pages) do
      add :identifiers, {:array, :string}
      add :origin_system, :string
      add :name, :string
      add :title, :string
      add :description, :text
      add :summary, :text
      add :browser_url, :string
      add :administrative_url, :string
      add :featured_image_url, :string
      add :currency, :string
      add :share_url, :string

      timestamps()
    end

    create unique_index(:fundraising_pages, [:name])

    alter table(:donations) do
      add :fundraising_page_id, references(:fundraising_pages)
    end
  end
end
