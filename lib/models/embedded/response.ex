defmodule Osdi.Response do
  use Ecto.Schema

  embedded_schema do
    field(:key, :string)
    field(:name, :string)
    field(:title, :string)
  end
end
