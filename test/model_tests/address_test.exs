defmodule AddressTest do
  use ExUnit.Case
  alias Osdi.{Repo, Address}

  test "get or insert address" do
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

  test "update address coordinates" do
    test_address = %Address{
      venue: "The Office",
      address_lines: ["714 S Gay St."],
      locality: "Knoxville",
      region: "TN",
      postal_code: "37902",
      time_zone: "America/New_York",
      location: %Geo.Point{coordinates: {35.9630028, -83.918997}, srid: nil}
    }

    address = %{id: id, location: old_geo_point} = Repo.insert!(test_address)

    new_coordinates = {32, 80}

    %{id: updated_id, location: new_geo_point} =
      Address.update_coordinates(address, new_coordinates)

    %{coordinates: {old_x, _}} = old_geo_point
    %{coordinates: {new_x, _}} = new_geo_point

    assert id == updated_id
    assert old_x != new_x
  end
end
