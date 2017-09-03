defmodule EventTest do
  use ExUnit.Case
  import ShorterMaps

  alias Osdi.{Repo, Person, Event}

  def create_fake_event do
    [organizer, creator] = Repo.all(Person) |> Enum.take(2)
    event = %Event{}

    [name, title, description, summary, browser_url, type, featured_image_url] =
      [Faker.Beer.name(), Faker.Beer.style(), Faker.Beer.yeast(), Faker.Beer.malt(),
       Faker.Internet.url(), Faker.Company.bs(), Faker.Internet.url()]

    start_date = DateTime.utc_now() |> Timex.shift(days: 4)
    end_date = DateTime.utc_now() |> Timex.shift(days: 4, hours: 4)

    tags = ~w(one two three)

    location = %{}

    new_event = Event.changeset(event, ~M(name, title, description, summary,
      browser_url, type, featured_image_url, start_date, end_date, organizer,
      creator, tags, location
    ))

    Repo.insert!(new_event)
  end

  test "create event with organizer, creator" do
    [organizer, creator] = Repo.all(Person) |> Enum.take(2)
    event = %Event{}

    [name, title, description, summary, browser_url, type, featured_image_url] =
      [Faker.Beer.name(), Faker.Beer.style(), Faker.Beer.yeast(), Faker.Beer.malt(),
       Faker.Internet.url(), Faker.Company.bs(), Faker.Internet.url()]

    start_date = DateTime.utc_now() |> Timex.shift(days: 4)
    end_date = DateTime.utc_now() |> Timex.shift(days: 4, hours: 4)

    tags = ~w(one two three)

    new_event = Event.changeset(event, ~M(name, title, description, summary,
      browser_url, type, featured_image_url, start_date, end_date, organizer,
      creator, tags
    ))

    assert %Event{} = create_fake_event()
  end

  test "add tags four, five, six" do
    %Event{id: id} =
      create_fake_event()
      |> Event.add_tags(~w(four, five, six))

    new_tags =
      Event
      |> Repo.get(id)
      |> Repo.preload(:tags)
      |> Map.get(:tags)

    assert length(new_tags) == 6
  end

  test "delete tags two, three" do
    %Event{id: id} =
      create_fake_event()
      |> Event.remove_tags(~w(two three))

    new_tags =
      Event
      |> Repo.get(id)
      |> Repo.preload(:tags)
      |> Map.get(:tags)

    assert length(new_tags) == 1
  end
end
