defmodule EventTest do
  use ExUnit.Case
  import ShorterMaps

  alias Osdi.{Repo, Person, Event}

  def create_fake_event do
    [organizer, creator] =
      Repo.all(Person) |> Repo.preload(~w(phone_numbers email_addresses)a) |> Enum.take(2)

    event = %Event{}

    [event_name, title, description, summary, browser_url, type, featured_image_url] =
      [
        Faker.Code.iban(),
        Faker.Beer.style(),
        Faker.Beer.yeast(),
        Faker.Beer.malt(),
        Faker.Internet.url(),
        "Phonebank",
        Faker.Internet.url()
      ]

    start_date = DateTime.utc_now() |> Timex.shift(days: 4)
    end_date = DateTime.utc_now() |> Timex.shift(days: 4, hours: 4)

    tags = ~w(one two three)

    location = %{
      locality: Faker.Company.bs(),
      venue: Faker.Beer.malt(),
      time_zone: "America/New_York",
      address_lines: [Faker.Company.bs()]
    }

    name = "#{organizer.given_name} #{organizer.family_name}"
    phone_number = organizer.phone_numbers |> List.first() |> Map.get(:number)
    email_address = organizer.email_addresses |> List.first() |> Map.get(:address)
    contact = %{mame: name, phone_number: phone_number, email_address: email_address}
    status = "confirmed"

    name = event_name

    new_event = Event.changeset(event, ~M(name, title, description, summary,
      browser_url, type, featured_image_url, start_date, end_date, organizer,
      creator, tags, location, contact, status
    ))

    Repo.insert!(new_event)
  end

  test "create event with organizer, creator, contact" do
    event = %Event{} = create_fake_event()
    assert is_map(event)
    assert %{name: _name} = event.contact
  end

  test "add tags four, five, six" do
    %Event{id: id} =
      create_fake_event()
      |> Event.add_tags(~w(four five six))

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
