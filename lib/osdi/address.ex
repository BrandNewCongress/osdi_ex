defmodule Osdi.Address do
  use Ecto.Schema
  import Ecto.Changeset

  @base_attrs ~w(
    venue address_lines location region postal_code country
    status time_zone location
  )a

  @associations ~w()a

  @derive {Poison.Encoder, only: @base_attrs ++ @associations}
  schema "addresses" do
    field :venue, :string
    field :address_lines, {:array, :string}
    field :locality, :string
    field :region, :string
    field :postal_code, :string
    field :country, :string, default: "United States of America"
    field :status, :string
    field :time_zone, :string
    field :location, Geo.Point

    timestamps()
  end

  def changeset(address, params \\ %{}) do
    address
    |> cast(params, @base_attrs)
  end
end
