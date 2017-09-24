defmodule Osdi.Repo.Migrations.Contact do
  use Ecto.Migration

  def change do
    create table(:contacts) do
      add :identifiers, {:array, :string}
      add :origin_system, :string
      add :action_date, :utc_datetime
      add :contact_type, :string
      add :input_type, :string
      add :success, :boolean
      add :status_code, :string

      add :target_id, references(:people)
      add :contactor_id, references(:people)

      timestamps()
    end

    create table(:questions) do
      add :identifiers, {:array, :string}
      add :origin_system, :string
      add :title, :string
      add :description, :string
      add :summary, :string
      add :question_type, :string
      add :responses, {:array, :map}

      add :creator_id, references(:people)
      add :modified_by_id, references(:people)

      timestamps()
    end

    create table(:answers) do
      add :identifiers, {:array, :string}
      add :origin_system, :string
      add :value, :string
      add :responses, {:array, :string}

      add :person_id, references(:people)
      add :question_id, referneces(:questions)

      timestamps()
    end
  end
end
