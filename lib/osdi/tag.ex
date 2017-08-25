defmodule Osdi.Tag do
  use Ecto.Schema

  schema "tags" do
    field :name, :string
    field :origin_system, :string
    field :description, :string

    has_many :taggings, Osdi.Tagging

    timestamps()
  end

  def changeset(tag, params \\ %{}) do
    tag
    |> Ecto.Changeset.cast(params, [:name, :origin_system, :description])
    |> Ecto.Changeset.validate_required([:name])
  end
end
