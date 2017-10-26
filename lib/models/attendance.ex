defmodule Osdi.Attendance do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Osdi.{Repo, Address, Event}

  @base_attrs ~w(origin_system action_date status attended)a
  @associations ~w(person event)a

  @derive {Poison.Encoder, only: @base_attrs}
  schema "attendances" do
    field(:origin_system, :string)
    field(:action_date, :utc_datetime)
    field(:status, :string)
    field(:attended, :boolean)

    embeds_one(:referrer_data, Osdi.ReferrerData)

    belongs_to(:person, Osdi.Person)
    belongs_to(:event, Osdi.Event)

    timestamps()
  end

  def changeset(attendance, params \\ %{}) do
    attendance
    |> cast(params, @base_attrs)
    |> cast_embed(:referrer_data)
    |> put_assoc(:person, params.person)
    |> put_assoc(:event, params.event)
  end

  def push(event_id, person, referrer_data \\ nil) do
    %{id: person_id} = person = Osdi.Person.push(person)

    existing =
      from(a in Osdi.Attendance, where: a.event_id == ^event_id and a.person_id == ^person_id)
      |> Repo.all()
      |> List.first()

    case existing do
      nil ->
        event = Repo.get(Event, event_id)

        %Osdi.Attendance{}
        |> changeset(%{
             referrer_data: referrer_data,
             action_date: DateTime.utc_now(),
             status: "accepted",
             person: person,
             event: event
           })
        |> Repo.insert!()

      attendance ->
        attendance
    end
  end
end
