defmodule DonationTest do
  use ExUnit.Case
  alias Osdi.{Repo, Person, Donation, FundraisingPage}

  test "fundraising page creation" do
    fp =
      Repo.insert!(%FundraisingPage{
        title: "title",
        description: "description",
        summary: "summary",
        browser_url: "https://www.jd.com",
        administrative_url: "https://admin.jd.com",
        featured_image_url: "https://featured.jd.com",
        currency: "USD",
        share_url: "https://share.jd.com",
        name: "fp-name"
      })

    assert %FundraisingPage{id: _id} = fp
  end

  test "direction donation creation" do
    fp =
      %FundraisingPage{}
      |> FundraisingPage.changeset(%{
           title: "with donatiosn",
           description: "this one will have donations",
           summary: "summary",
           browser_url: "https://www.jd.com",
           administrative_url: "https://admin.jd.com",
           featured_image_url: "https://featured.jd.com",
           currency: "USD",
           share_url: "https://share.jd.com",
           name: "fp-dummy-name"
         })
      |> Repo.insert!()

    assert %FundraisingPage{id: fp_id} = fp

    person = Repo.all(Person) |> Enum.take(1) |> List.first()
    donation = %Donation{}

    amount = Faker.Commerce.price()

    ref_source = Faker.Code.isbn()

    new_donation =
      Donation.changeset(donation, %{
        origin_system: "actblue",
        action_date: DateTime.utc_now(),
        amount: amount,
        recipients: [
          %{
            display_name: "Brand New Congress",
            legal_name: "Brand New Congress PAC",
            amount: amount
          }
        ],
        referrer_data: %{source: ref_source, referrer: ref_source},
        person: person,
        fundraising_page: fp
      })

    assert {:ok, _donation} = Repo.insert(new_donation)
  end
end
