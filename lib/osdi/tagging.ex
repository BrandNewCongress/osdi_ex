defmodule Osdi.Tagging do
  use Ecto.Schema
  import Ecto.Changeset

  schema "taggings" do
    field :item_type, :string
    field :origin_system, :string

    belongs_to :person, Osdi.Person
    belongs_to :tag, Osdi.Tag

    timestamps()
  end

  def changeset(tagging, params \\ %{}) do
    tagging
    |> cast(params, [:item_type, :origin_system])
    |> put_assoc(:person, params.person)
    |> put_assoc(:tag, params.tag)
  end
end
