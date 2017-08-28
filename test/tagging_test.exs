defmodule TaggingTest do
  use ExUnit.Case
  alias Osdi.{Repo, Tag, Tagging, Person}

  test "create tag" do
    tag = %Tag{}
    [name] =
      :alphanumeric
      |> StreamData.string()
      |> Stream.filter(fn str -> String.length(str) > 5 end)
      |> Enum.take(1)

    new_tag = Tag.changeset(tag, %{name: name})
    {:ok, _tag} = Repo.insert(new_tag)
  end

  test "tag someone" do
    [someone] = Repo.all(Person) |> Enum.take(1)
    [tag] = Repo.all(Tag) |> Enum.take(1)

    tagging = %Tagging{}
    new_tagging = Tagging.changeset(tagging, %{person: someone, tag: tag})

    {:ok, _tagging} = Repo.insert(new_tagging)
  end
end
