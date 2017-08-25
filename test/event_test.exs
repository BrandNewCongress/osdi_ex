defmodule EventTest do
  use ExUnit.Case
  import ShorterMaps

  test "create event with organizer, creator" do
    [organizer, creator] = Osdi.Repo.all(Osdi.Person) |> Enum.take(2)
    event = %Osdi.Event{}

    [name, title, description, summary, browser_url, type, featured_image_url] =
      :alphanumeric
      |> StreamData.string()
      |> Stream.filter(fn str -> String.length(str) > 2 end)
      |> Enum.take(7)

    start_date = DateTime.utc_now() |> Timex.shift(days: 4)
    end_date = DateTime.utc_now() |> Timex.shift(days: 4, hours: 4)

    new_event = Osdi.Event.changeset(event, ~M(name, title, description, summary,
      browser_url, type, featured_image_url, start_date, end_date, organizer,
      creator
    ))

    assert {:ok, _event} = Osdi.Repo.insert(new_event)
  end
end
