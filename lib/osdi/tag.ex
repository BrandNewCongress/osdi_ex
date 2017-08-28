defmodule Osdi.Tag do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tags" do
    field :name, :string
    field :origin_system, :string
    field :description, :string

    has_many :taggings, Osdi.Tagging

    timestamps()
  end

  def changeset(tag, params \\ %{}) do
    tag
    |> cast(params, [:name, :origin_system, :description])
    |> unique_constraint(:name)
    |> validate_required([:name])
  end
end
