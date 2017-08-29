defmodule DonationTest do
  use ExUnit.Case
  alias Osdi.{Repo, Person, Donation}

  test "direction donation creation" do
    person = Repo.all(Person) |> Enum.take(1) |> List.first()
    donation = %Donation{}

    amount = Faker.Commerce.price()

    ref_source = Faker.Code.isbn()

    new_donation = Donation.changeset(donation, %{
      origin_system: "actblue", action_date: DateTime.utc_now(),
      amount: amount,
      recipients: [%{display_name: "Brand New Congress", legal_name: "Brand New Congress PAC", amount: amount}],
      referrer_data: %{source: ref_source, referrer: ref_source},
      person: person
    })

    assert {:ok, _donation} = Repo.insert(new_donation)
  end
end
