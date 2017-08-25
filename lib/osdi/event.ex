defmodule Osdi.Event do
  use Ecto.Schema

  schema "events" do
    field :name, :string
    field :title, :string
    field :description, :string
    field :summary, :string
    field :browser_url, :string
    field :type, :string
    field :location, :map
    field :featured_image_url, :string
    field :start_date, :utc_datetime
    field :end_date, :utc_datetime
    field :calendar, :string

    timestamps()
  end
end
