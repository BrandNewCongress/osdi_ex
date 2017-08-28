defmodule Osdi.NbToOsdi do
  def go do
    {:ok, _agent} = Nb.start_link
    {:ok, _conn} = Redix.start_link(System.get_env("REDIS_URL"), name: :redix)

    last_sync = get_since() |> IO.inspect |> DateTime.to_iso8601()
    next_sync = DateTime.utc_now()

    start = Time.utc_now()

    "people"
    |> Nb.Api.stream([query: %{updated_since: last_sync}])
    |> ParallelStream.map(&sync_person/1, num_workers: 4, worker_work_ratio: 1)
    |> Enum.take(1)
    |> Enum.to_list()

    set_since(next_sync)

    done = Time.utc_now()
    IO.inspect Time.diff(done, start, :microsecond)

  end

  defp to_atom_map(map) when is_map(map), do: Map.new(map, fn {k, v} -> {String.to_atom(k), to_atom_map(v)} end)
  defp to_atom_map(v), do: v

  defp sync_person(person) do
    import Ecto.Query, only: [from: 2]

    IO.puts "Begging person #{person["id"]}"

    query = from p in Osdi.Person, where: p.id == ^person["id"]

    existing =
      case Osdi.Repo.one(query) do
        nil -> %Osdi.Person{}
        existing -> existing
      end

    params =
      person
      |> fetch_full_if_required()
      |> to_atom_map()
      |> Transformers.Nb.People.to_map()

    existing
    |> Osdi.Person.changeset(params)
    |> Osdi.Repo.insert()
    |> IO.inspect
  end

  defp fetch_full_if_required(person = %{"id" => id}) do
    if person["twitter_id"] != nil or person["has_facebook"] do
      Nb.People.show(id)
    else
      person
    end
  end

  defp get_since do
    case Redix.command!(:redix, ["GET", "last_successful_sync"]) do
      nil -> DateTime.utc_now() |> Timex.shift(years: -5)
      last_sync ->
        last_sync
        |> Integer.parse()
        |> Tuple.to_list()
        |> List.first()
        |> DateTime.from_unix!()
    end
  end

  defp set_since(dt) do
    Redix.command!(:redix, ["SET", "last_successful_sync", dt |> DateTime.to_unix()])
  end
end
