defmodule Manual.DefaultSummary do
  import Ecto.Query
  alias Osdi.{Event, Repo}

  def go do
    from(e in Event, where: is_nil(e.summary))
    |> Repo.all()
    |> Enum.map(&add_default_summary/1)
  end

  def add_default_summary(event = %Event{description: description}) do
    try do
      IO.puts("Summarizing event #{event.id}")

      summary =
        String.slice(description, 1..200) <>
          if String.length(description) > 200, do: "...", else: ""

      event
      |> Ecto.Changeset.change(%{summary: summary})
      |> Repo.update!()
    rescue
      _e ->
        IO.puts("Could not create summary for event #{event.id}")
    end
  end
end
