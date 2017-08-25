defmodule TaggingTest do
  use ExUnit.Case

  test "create tag" do
    tag = %Osdi.Tag{}
    [name] =
      :alphanumeric
      |> StreamData.string()
      |> Stream.filter(fn str -> String.length(str) > 5 end)
      |> Enum.take(1)

    new_tag = Osdi.Tag.changeset(tag, %{name: name})
    {:ok, _tag} = Osdi.Repo.insert(new_tag)
  end

  test "tag someone" do
    [someone] = Osdi.Repo.all(Osdi.Person) |> Enum.take(1)
    [tag] = Osdi.Repo.all(Osdi.Tag) |> Enum.take(1)

    tagging = %Osdi.Tagging{}
    new_tagging = Osdi.Tagging.changeset(tagging, %{person: someone, tag: tag})

    {:ok, _tagging} = Osdi.Repo.insert(new_tagging)
  end
end
