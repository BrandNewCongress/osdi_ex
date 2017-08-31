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

  # Make this test pass
  test "person push, name overwrite, add email" do
    mock_person = %Person{
      given_name: Faker.Name.first_name(),
      family_name: Faker.Name.last_name(),
      email_addresses: [%{address: Faker.Internet.email(), primary: true, status: "subscribed"}],
      phone_numbers: [%{number: Faker.Phone.EnUs.phone(), do_not_call: false, sms_capable: true}],
      tags: 1..3
        |> Enum.map(fn _ -> Faker.Pokemon.name() end)
        |> Tag.get_or_insert_all()}

    insertable_mock =
      mock_person
      |> Map.put(:email_addresses, (Enum.map mock_person.email_addresses, &EmailAddress.get_or_insert/1))
      |> Map.put(:phone_numbers, (Enum.map mock_person.phone_numbers, &PhoneNumber.get_or_insert/1))

    {:ok, %Person{id: created_id}} = Repo.insert(insertable_mock)

    modified =
      mock_person
      |> Map.put(:email_addresses, [%{address: Faker.Internet.email(), primary: true, status: "subscribed"}])

    insertable_modified =
      mock_person
      |> Map.put(:email_addresses, (Enum.map modified.email_addresses, &EmailAddress.get_or_insert/1))
      |> Map.put(:phone_numbers, (Enum.map modified.phone_numbers, &PhoneNumber.get_or_insert/1))

    pushed = Person.push(insertable_modified)

    assert pushed.id == created_id
    assert length(pushed.email_addresses) == 2
    assert length(pushed.phone_numbers) == 1
  end

  test "raw insert" do
    assert %Person{} = Person.push(%{additional_name: nil, attendances: nil, birthdate: nil,
      email_addresses: [%{address: "heidiwjackson@gmail.com", primary: true,
         status: "subscribed"}], family_name: "", gender: nil, given_name: "",
      honorific_prefix: nil, honorific_suffix: nil, languages_spoken: [],
      parties: nil, party_identification: nil,
      phone_numbers: [%{do_not_call: false, number: "9176573355",
         number_type: "Home", primary: false, sms_capable: false}],
      postal_addresses: [], profiles: [],
      taggings: [%{created_at: "2017-08-31T09:26:12-04:00",
         tag: %{name: "Action: Joined Website: Justice Democrats"}}]})
  end
end
