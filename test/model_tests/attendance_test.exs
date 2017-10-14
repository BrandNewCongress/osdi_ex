defmodule AttendanceTest do
  use ExUnit.Case
  import ShorterMaps

  alias Osdi.{Repo, Event, Person, Attendance, Address}

  test "new rsvp" do
    event = Repo.all(Event) |> Enum.take(1) |> List.first()
    person = Repo.all(Person) |> Enum.take(1) |> List.first()

    attendance = %Attendance{}

    origin_system = "custom"
    action_date = DateTime.utc_now()
    status = "confirmed"
    attended = false

    new_rsvp = Attendance.changeset(attendance, ~M(
      origin_system, action_date, status, attended, event, person
    ))

    {:ok, _rsvp} = Repo.insert(new_rsvp)
  end

  test "attendance push" do
    event = Repo.all(Event) |> Enum.take(1) |> List.first()

    rsvp_data =
      %{given_name: Faker.Name.first_name(), family_name: Faker.Name.last_name(),
        email_address: Faker.Internet.email(), phone_number: Faker.Phone.EnUs.phone(),
        postal_address: %Address{
          venue: "Ben's Place Office",
          address_lines: ["719 S Gay St."],
          locality: "Knoxville",
          region: "TN",
          postal_code: "37902",
          time_zone: "America/New_York",
          location: %Geo.Point{coordinates: {35.9630028, -83.918997}, srid: nil}
      }}

    %{id: first_attendance_id, person_id: first_person_id,
      referrer_data: referrer_test_data} = Attendance.push(event.id, rsvp_data, %{source: "test_source"})
    %{id: second_attendance_id, person_id: second_person_id} = Attendance.push(event.id, rsvp_data, %{source: "test_source"})
    %{postal_addresses: [%{address_lines: [line_zero | _]} | _]} = Repo.get(Person, second_person_id) |> Repo.preload(:postal_addresses)

    assert first_person_id = second_person_id
    assert first_attendance_id = second_attendance_id
    assert "719 S Gay St." = line_zero
    assert "test_source" == referrer_test_data.source
  end
end
