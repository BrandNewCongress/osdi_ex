defmodule PersonSignupHelperTest do
  use ExUnit.Case
  alias Osdi.{Repo, Person}

  test "person signup helper" do
    body = %{
      person: %{
        given_name: Faker.Name.first_name(),
        family_name: Faker.Name.last_name(),
        email_addresses: [%{address: Faker.Internet.email(), primary: true, status: "subscribed"}],
        phone_numbers: [%{number: Faker.Phone.EnUs.phone(), do_not_call: false, sms_capable: true}],
      },
      add_tags: Enum.map(1..3, fn _ -> Faker.Pokemon.name() end)
    }

    p = Osdi.PersonSignup.main(body)
    created = Repo.get(Person, p.id) |> Repo.preload([:tags])

    assert %Person{id: id} = created
    assert length(created.tags) == 3
  end
end
