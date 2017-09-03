defmodule Osdi.Event do
  use Ecto.Schema
  import Ecto.Changeset
  alias Osdi.{Tag, Repo}

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
    many_to_many :tags, Osdi.Tag, join_through: "event_taggings", on_replace: :delete
    belongs_to :location, Osdi.Address, foreign_key: :address_id

    timestamps()
  end

  def changeset(event, params \\ %{}) do
    event
    |> cast(params, @base_attrs)
    |> cast_assoc(:location)
    |> put_assoc(:creator, params.creator)
    |> put_assoc(:organizer, params.organizer)
    |> put_assoc(:tags, params.tags |> Tag.get_or_insert_all())
  end

  def add_tags(event = %Osdi.Event{tags: current_tags}, tags) when is_list(current_tags) do
    IO.inspect event

    current_tagstrings = current_tags |> Enum.map(&(&1.name))

    records =
      tags
      |> Enum.concat(current_tagstrings)
      |> Tag.get_or_insert_all()

    IO.inspect records

    event
    |> change(tags: records)
    |> Repo.update!()
  end

  def add_tags(event = %Osdi.Event{id: id}, tags) do
    Osdi.Event
    |> Repo.get(id)
    |> Repo.preload(:tags)
    |> add_tags(tags)
  end

  def remove_tags(event = %Osdi.Event{}, tags) do
    records =
      event.tags
      |> Enum.map(&(&1.name))
      |> Enum.reject(fn tag -> Enum.member?(tags, tag) end)
      |> Tag.get_or_insert_all()

    event
    |> change(tags: records)
    |> Repo.update!()
  end
end
