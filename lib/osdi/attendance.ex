defmodule Osdi.Attendance do
  use Ecto.Schema

  schema "attendances" do
    field :origin_system, :string
    field :action_date, :utc_datetime
    field :status, :string
    field :attended, :boolean
    field :referrer_data, :map

    belongs_to :person, Osdi.Person
    belongs_to :event, Osdi.Event

    timestamps()
  end

  def changeset(attendance, params \\ %{}) do
    attendance
    |> Ecto.Changeset.cast(params, [:origin_system, :action_date, :status, :attended, :referrer_data])
    |> Ecto.Changeset.put_assoc(:person, params.person)
    |> Ecto.Changeset.put_assoc(:event, params.event)
  end
end