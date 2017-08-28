defmodule Osdi.Address do
  use Ecto.Schema

  embedded_schema do
    field :venue, :string
    field :address_lines, {:array, :string}
    field :locality, :string
    field :region, :string
    field :postal_code, :string
    field :country, :string, default: "United States of America"
    field :status, :string
    field :time_zone, :string
    field :location, :map
  end
end
