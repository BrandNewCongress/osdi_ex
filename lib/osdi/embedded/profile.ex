defmodule Osdi.Profile do
  use Ecto.Schema

  embedded_schema do
    field :provider, :string
    field :url, :string
    field :handle, :string
  end
end
