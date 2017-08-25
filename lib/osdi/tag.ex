defmodule Osdi.Tag do
  use Ecto.Schema

  schema "tag" do
    field :name, :string
    field :origin_system, :string
    field :description, :string

    timestamps()
  end
end
