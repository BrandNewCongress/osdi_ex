defmodule Osdi.Tag do
  use Ecto.Schema

  schema "tags" do
    field :item_type, :string
    field :origin_system, :string
  end
end
