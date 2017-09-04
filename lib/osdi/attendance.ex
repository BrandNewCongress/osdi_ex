defmodule Osdi.Attendance do
  use Ecto.Schema
  import Ecto.Changeset

  @base_attrs ~w(origin_system action_date status attended)a
  @associations ~w(person event)a

  @derive {Poison.Encoder, only: @base_attrs ++ @associations}
  schema "attendances" do
    field :origin_system, :string
    field :action_date, :utc_datetime
    field :status, :string
    field :attended, :boolean

    embeds_one :referrer_data, Osdi.ReferrerData

    belongs_to :person, Osdi.Person
    belongs_to :event, Osdi.Event

    timestamps()
  end

  def changeset(attendance, params \\ %{}) do
    attendance
    |> cast(params, @base_attrs)
    |> cast_embed(:referrer_data)
    |> put_assoc(:person, params.person)
    |> put_assoc(:event, params.event)
  end
end
