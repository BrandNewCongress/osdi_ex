defmodule AttendanceTest do
  use ExUnit.Case
  import ShorterMaps

  test "new rsvp" do
    event = Osdi.Repo.all(Osdi.Event) |> Enum.take(1) |> List.first()
    person = Osdi.Repo.all(Osdi.Person) |> Enum.take(1) |> List.first()

    attendance = %Osdi.Attendance{}

    origin_system = "custom"
    action_date = DateTime.utc_now()
    status = "confirmed"
    attended = false

    new_rsvp = Osdi.Attendance.changeset(attendance, ~M(origin_system,
      action_date, status, attended, event, person
    ))

    {:ok, _rsvp} = Osdi.Repo.insert(new_rsvp)
  end
end
