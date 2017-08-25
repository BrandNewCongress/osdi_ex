defmodule Osdi.Attendance do
  use Ecto.Schema

  schema "attendance" do
    field :origin_system, :string
    field :action_date, :utc_datetime
    field :status, :string
    field :attended, :boolean
    field :referrer_data, :map

    timestamps()
  end
end
