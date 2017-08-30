defmodule SignupTest do
  use ExUnit.Case
  alias Osdi.{Person, Repo, Tag, EmailAddress, PhoneNumber}

  test "nested associations person insert" do
    assert {:ok, _person} = Repo.insert(%Person{
      given_name: Faker.Name.first_name(),
      family_name: Faker.Name.last_name(),
      email_addresses: [%{address: Faker.Internet.email(), primary: true, status: "subscribed"}]
        |> Enum.map(&EmailAddress.get_or_insert/1),
      phone_numbers: [%{number: Faker.Phone.EnUs.phone(), do_not_call: false, sms_capable: true}]
        |> Enum.map(&PhoneNumber.get_or_insert/1),
      tags: 1..3
        |> Enum.map(fn _ -> Faker.Pokemon.name() end)
        |> Tag.get_or_insert_all()
    })
  end
end
