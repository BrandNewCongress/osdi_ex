defmodule Osdi.Address do
  use Ecto.Schema
  import Ecto.Changeset

  @base_attrs ~w(
    venue address_lines location locality region postal_code country
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

  def encode_model(address = %Osdi.Address{location: %Geo.Point{coordinates: {x, y}}}) do
    %Osdi.Address{address | location: [x, y]}
  end

  def encode_model(address) do
    address
  end

  defimpl Poison.Encoder, for: Osdi.Address do
    def encode(address, options) do
      address
      |> Osdi.Address.encode_model()
      |> Map.take(~w(venue address_lines location region postal_code country status time_zone location)a)
      |> Poison.Encoder.Map.encode(options)
    end
  end

  def changeset(address, params \\ %{}) do
    address
    |> cast(params, @base_attrs)
  end
end
