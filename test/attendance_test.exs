defmodule AttendanceTest do
  use ExUnit.Case
  import ShorterMaps

  alias Osdi.{Repo, Event, Person, Attendance}

  test "new rsvp" do
    event = Repo.all(Event) |> Enum.take(1) |> List.first()
    person = Repo.all(Person) |> Enum.take(1) |> List.first()

    attendance = %Attendance{}

    origin_system = "custom"
    action_date = DateTime.utc_now()
    status = "confirmed"
    attended = false

    new_rsvp = Attendance.changeset(attendance, ~M(origin_system,
      action_date, status, attended, event, person
    ))

    {:ok, _rsvp} = Repo.insert(new_rsvp)
  end
end
