defmodule Manual.SplitMegaPeople do
  import Ecto.Query
  alias Osdi.{Repo, Person}

  def go do
    mega_peeps = Repo.all(from pe in "people_emails",
      select: {pe.person_id, count(pe.id)},
      group_by: pe.person_id,
      order_by: [desc: count(pe.id)],
      limit: 20)

    Enum.each mega_peeps, fn {pid, _count} ->
      person =
        Repo.all(from p in Person, where: p.id == ^pid)

      # id = person |> List.last() |> Map.get(:id)

      _emails = person
        |> Repo.preload(:email_addresses)
        |> Enum.flat_map(& &1.email_addresses)
        |> Enum.map(& &1.address)

      _phones = person
        |> Repo.preload(:phone_numbers)
        |> Enum.flat_map(& &1.phone_numbers)
        |> Enum.map(& &1.number)
    end
  end
end
