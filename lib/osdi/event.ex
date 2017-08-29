defmodule Osdi.Event do
  use Ecto.Schema
  import Ecto.Changeset

  @base_attrs ~w(
    name title description summary browser_url type
    featured_image_url start_date end_date calendar
  )

  schema "events" do
    field :name, :string
    field :title, :string
    field :description, :string
    field :summary, :string
    field :browser_url, :string
    field :type, :string
    field :featured_image_url, :string
    field :start_date, :utc_datetime
    field :end_date, :utc_datetime
    field :calendar, :string

    has_one :creator, Osdi.Person
    has_one :organizer, Osdi.Person
    has_one :modified_by, Osdi.Person

    has_many :attendances, Osdi.Attendance
    belongs_to :location, Osdi.Address, foreign_key: :address_id

    timestamps()
  end

  def changeset(event, params \\ %{}) do
    event
    |> cast(params, @base_attrs)
    |> cast_assoc(:location)
    |> put_assoc(:creator, params.creator)
    |> put_assoc(:organizer, params.organizer)
  end
end
