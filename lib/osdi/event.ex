defmodule Osdi.Event do
  use Ecto.Schema
  import Ecto.Changeset
  alias Osdi.{Tag, Repo}

  @base_attrs ~w(
    name title description summary browser_url type
    featured_image_url start_date end_date status
  )a

  @associations ~w(
    creator organizer modified_by location tags
  )a

  @embeds ~w(host)a

  @derive {Poison.Encoder, only: @base_attrs ++ @associations}
  schema "events" do
    field :identifiers, {:array, :string}
    field :name, :string
    field :title, :string
    field :description, :string
    field :summary, :string
    field :browser_url, :string
    field :type, :string
    field :status, :string
    field :featured_image_url, :string
    field :start_date, :utc_datetime
    field :end_date, :utc_datetime

    embeds_one :host, Osdi.Host

    belongs_to :creator, Osdi.Person
    belongs_to :organizer, Osdi.Person
    belongs_to :modified_by, Osdi.Person
    belongs_to :location, Osdi.Address, foreign_key: :address_id

    has_many :attendances, Osdi.Attendance
    many_to_many :tags, Osdi.Tag, join_through: "event_taggings", on_replace: :delete

    timestamps()
  end

  def changeset(event, params \\ %{}) do
    event
    |> cast(params, @base_attrs)
    |> cast_assoc(:location)
    |> cast_embed(:host)
    |> put_assoc(:creator, params.creator)
    |> put_assoc(:organizer, params.organizer)
    |> put_assoc(:tags, params.tags |> Tag.get_or_insert_all())
  end

  def add_tags(event = %Osdi.Event{tags: current_tags}, tags) when is_list(current_tags) do
    current_tagstrings = current_tags |> Enum.map(&(&1.name))

    records =
      tags
      |> Enum.concat(current_tagstrings)
      |> Tag.get_or_insert_all()

    event
    |> change(tags: records)
    |> Repo.update!()
  end

  def add_tags(_event = %Osdi.Event{id: id}, tags) do
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

  def set_tags(event = %Osdi.Event{}, tags) do
    records = tags |> Tag.get_or_insert_all()

    event
    |> change(tags: records)
    |> Repo.update!()
  end

  def slug_for(title, date) do
    title_part = title |> String.downcase() |> String.replace(" ", "-")
    date_part = date |> DateTime.to_date() |> Date.to_string |> String.split("-") |> Enum.slice(1..3) |> Enum.join("-")

    "#{title_part}-#{date_part}"
  end
end
