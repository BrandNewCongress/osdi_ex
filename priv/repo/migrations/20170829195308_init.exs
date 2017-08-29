defmodule Osdi.Repo.Migrations.Init do
  use Ecto.Migration

  def change do
    create table(:people) do
      add :given_name, :string
      add :family_name, :string
      add :additional_name, :string
      add :honorific_prefix, :string
      add :honorific_suffix, :string
      add :gender, :string
      add :birthdate, :date
      add :languages_spoken, {:array, :string}
      add :party_identification, :string
      add :parties, {:array, :map}, default: []
      add :profiles, {:array, :map}, default: []

      timestamps()
    end

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

      add :creator, references(:people)
      add :organizer, references(:people)
      add :modified_by, references(:people)

      timestamps()
    end

    create table(:addresses) do
      add :venue, :string
      add :address_lines, {:array, :string}
      add :locality, :string
      add :region, :string
      add :postal_code, :string
      add :country, :string, default: "United States of America"
      add :status, :string
      add :time_zone, :string
      add :location, :geometry

      timestamps()
    end

    create table(:people_addresses) do
      add :address_id, references(:addresses)
      add :person_id, references(:people)
    end

    alter table(:events) do
      add :address_id, references(:addresses)
    end

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

      add :person_id, references(:people)

      timestamps()
    end

    create table(:tags) do
      add :name, :string, unique: true
      add :origin_system, :string
      add :description, :string

      timestamps()
    end

    create unique_index(:tags, [:name])

    create table(:people_taggings) do
      add :tag_id, references(:tags)
      add :person_id, references(:people)

      timestamps()
    end

    create table(:phone_numbers) do
      add :primary, :string
      add :number, :string
      add :extension, :string
      add :description, :string
      add :number_type, :string
      add :operator, :string
      add :country, :string
      add :sms_capable, :boolean
      add :do_not_call, :boolean

      timestamps()
    end

    create unique_index(:phone_numbers, [:number])

    create table(:people_phones) do
      add :phone_number_id, references(:phone_numbers)
      add :person_id, references(:people)
    end

    create table(:email_addresses) do
      add :primary, :boolean
      add :address, :string
      add :address_type, :string
      add :status, :string
    end

    create unique_index(:email_addresses, [:address])

    create table(:people_emails) do
      add :email_address_id, references(:email_addresses)
      add :person_id, references(:people)
    end

    create table(:attendances) do
      add :origin_system, :string
      add :action_date, :utc_datetime
      add :status, :string
      add :attended, :boolean
      add :referrer_data, :map

      add :person_id, references(:people)
      add :event_id, references(:events)

      timestamps()
    end
  end
end
