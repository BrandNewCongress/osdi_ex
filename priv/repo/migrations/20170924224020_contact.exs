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
      add :custom_fields, :map

      add :target_id, references(:people)
      add :contactor_id, references(:people)
      add :contact_effort_id, references(:contact_efforts)

      timestamps()
    end

    create table(:questions) do
      add :identifiers, {:array, :string}
      add :origin_system, :string
      add :title, :string
      add :description, :text
      add :summary, :text
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
      add :contact_id, references(:contacts)

      timestamps()
    end

    create table(:script_questions) do
      add :identifiers, {:array, :string}
      add :sequence, :integer

      add :question_id, references(:question)
      add :script_id, references(:scripts)

      timestamps()
    end

    create table(:scripts) do
      add :identifiers, {:array, :string}
      add :origin_sytem, :string
      add :title, :string
      add :description, :text
      add :summary, :text

      add :creator_id, references(:people)
      add :modified_by_id, references(:people)
      add :contact_effort_id, references(:contact_efforts)

      timestamps()
    end

    create table(:contact_efforts) do
      add :identifiers, {:array, :string}
      add :origin_sytem, :string
      add :name, :string
      add :title, :string
      add :description, :text
      add :summary, :text
      add :start_date, :utc_datetime
      add :end_date, :utc_datetime
      add :type, :string

      add :creator_id, references(:people)
      add :modified_by_id, references(:people)

      timestamps()
    end
  end
end
