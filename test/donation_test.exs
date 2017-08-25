defmodule Donation do
  use ExUnit.Case

  test "direction donation creation" do
    person = Osdi.Repo.all(Osdi.Person) |> Enum.take(1) |> List.first()
    donation = %Osdi.Donation{}

    amount = StreamData.integer(1..200) |> Enum.take(1) |> List.first()

    ref_source =
      :alphanumeric
      |> StreamData.string()
      |> Stream.filter(fn str -> String.length(str) > 2 end)
      |> Enum.take(1)
      |> List.first()

    new_donation = Osdi.Donation.add(donation, %{
      origin_system: "actblue", action_date: DateTime.utc_now(),
      amount: amount,
      recipients: [%{display_name: "Brand New Congress", legal_name: "Brand New Congress PAC", amount: amount}],
      referrer_data: %{source: ref_source, referrer: ref_source},
      person: person
    })

    assert {:ok, _person} = Osdi.Repo.insert(new_donation)
  end
end
