defmodule Osdi.Tagging do
  use Ecto.Schema

  schema "people_taggings" do
    belongs_to :person, Osdi.Person
    belongs_to :tag, Osdi.Tag

    timestamps()
  end
end
