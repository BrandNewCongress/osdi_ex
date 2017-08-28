defmodule Osdi.Tagging do
  use Ecto.Schema

  schema "taggings" do
    field :item_type, :string
    field :origin_system, :string

    belongs_to :person, Osdi.Person
    belongs_to :tag, Osdi.Tag

    timestamps()
  end

  def changeset(tagging, params \\ %{}) do
    tagging
    |> Ecto.Changeset.cast(params, [:item_type, :origin_system])
    |> Ecto.Changeset.put_assoc(:person, params.person)
    |> Ecto.Changeset.put_assoc(:tag, params.tag)
  end
end
