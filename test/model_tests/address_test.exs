defmodule AddressTest do
  use ExUnit.Case
  alias Osdi.{Repo, Address}

  test "new rsvp" do
    test_address = %Address{
      venue: "The Office",
      address_lines: ["714 S Gay St."],
      locality: "Knoxville",
      region: "TN",
      postal_code: "37902",
      time_zone: "America/New_York",
      location: %Geo.Point{coordinates: {35.9630028, -83.918997}, srid: nil}
    }

    %{id: first_id} = Address.get_or_insert(test_address)
    %{id: second_id} = Address.get_or_insert(test_address)

    assert first_id == second_id
  end
end
