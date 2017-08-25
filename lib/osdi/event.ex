defmodule Osdi.Event do
  use Ecto.Schema

  @base_attrs ~w(name title description summary browser_url type location featured_image_url start_date end_date calendar)

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

    has_one :creator, Osdi.Person
    has_one :organizer, Osdi.Person
    has_one :modified_by, Osdi.Person

    has_many :attendances, Osdi.Attendance

    timestamps()
  end

  def changeset(event, params \\ %{}) do
    IO.inspect params

    event
    |> Ecto.Changeset.cast(params, @base_attrs)
    |> Ecto.Changeset.put_assoc(:creator, params.creator)
    |> Ecto.Changeset.put_assoc(:organizer, params.organizer)
  end
end
