defmodule EditHistoryTest do
  use ExUnit.Case
  alias Osdi.{Repo, Event, Person, EventEdit, PersonEdit}

  test "record, group fetch event edit history" do
    event = Repo.all(Event) |> Enum.take(1) |> List.first()

    Repo.insert!(%EventEdit{
      actor: "lynn@justicedemocrats.com",
      event_id: event.id,
      edit: %{"location.time_zone" => "America/New_York"}
    })

    Repo.insert!(%EventEdit{
      actor: "lynn@justicedemocrats.com",
      event_id: event.id,
      edit: %{"name" => "new_event_name"}
    })

    edits =
      EventEdit.edits_by_within_for(
        "lynn@justicedemocrats.com",
        %Timex.Duration{megaseconds: 0, microseconds: 0, seconds: 1},
        event.id
      )

    assert [%{} | _] = edits
    assert 2 = length(edits)
  end

  test "record, group fetch people edit history" do
    person = Repo.all(Event) |> Enum.take(1) |> List.first()

    Repo.insert!(%PersonEdit{
      actor: "lynn@justicedemocrats.com",
      person_id: person.id,
      edit: %{"last_name" => "David"}
    })

    Repo.insert!(%PersonEdit{
      actor: "lynn@justicedemocrats.com",
      person_id: person.id,
      edit: %{"first_name" => "Josh"}
    })

    edits =
      PersonEdit.edits_by_within_for(
        "lynn@justicedemocrats.com",
        %Timex.Duration{megaseconds: 0, microseconds: 0, seconds: 1},
        person.id
      )

    assert [%{} | _] = edits
    assert 2 = length(edits)
  end
end
