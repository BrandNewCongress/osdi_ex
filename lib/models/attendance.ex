defmodule Osdi.Attendance do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Osdi.{Repo, EmailAddress, Address, PhoneNumber, Event}

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

  def push(event_id, person) do
    %{given_name: first_name, family_name: last_name, email_address: email_address,
      phone_number: phone_number, postal_address: postal_address} = person

    %{id: person_id} = person = Osdi.Person.push(%{given_name: first_name, family_name: last_name,
      email_addresses: [%{address: email_address, primary: true}],
      phone_numbers: [%{number: phone_number, primary: true}],
      postal_addresses: [postal_address] |> Enum.map(&Address.get_or_insert/1)
    })

    existing =
      (from a in Osdi.Attendance, where: a.event_id == ^event_id and a.person_id == ^person_id)
      |> Repo.all()
      |> List.first()

    case existing do
      nil ->
        event = Repo.get(Event, event_id)

        attendance = %Osdi.Attendance{
          action_date: DateTime.utc_now(), status: "accepted",
          person: person, event: event, referrer_data: %{}
        }

        Repo.insert!(attendance)

      attendance -> attendance
    end
  end
end
