defmodule Osdi.Tagging do
  use Ecto.Schema

  schema "taggings" do
    field :item_type, :string
    field :origin_system, :string
  end
end
