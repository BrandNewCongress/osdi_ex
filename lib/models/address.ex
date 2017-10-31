defmodule Osdi.Address do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  @base_attrs ~w(
    venue address_lines location locality region postal_code country
    time_zone location public
  )a

  schema "addresses" do
    field(:venue, :string)
    field(:address_lines, {:array, :string})
    field(:locality, :string)
    field(:region, :string)
    field(:postal_code, :string)
    field(:country, :string, default: "United States of America")
    field(:time_zone, :string)
    field(:public, :boolean)
    field(:location, Geo.Point)

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
      |> Map.take(
           ~w(venue address_lines locality region postal_code country time_zone location public)a
         )
      |> Poison.Encoder.Map.encode(options)
    end
  end

  def changeset(address, params \\ %{}) do
    address
    |> cast(params, @base_attrs)
  end

  def get_or_insert(address = %Osdi.Address{address_lines: address_lines})
      when is_list(address_lines) do
    address_line_zero =
      case address_lines do
        nil -> nil
        list -> list |> List.first()
      end

    query = dynamic([a], ^address_line_zero in a.address_lines)

    no_conflicts =
      Map.take(address, ~w(locality region postal_code)a)
      |> Enum.filter(fn {_key, val} -> val != nil end)

    query =
      case address.locality do
        nil -> query
        locality -> dynamic([a], (is_nil(a.locality) or a.locality == ^locality) and ^query)
      end

    query =
      case address.postal_code do
        nil ->
          query

        postal_code ->
          dynamic([a], (is_nil(a.postal_code) or a.postal_code == ^postal_code) and ^query)
      end

    query =
      case address.region do
        nil -> query
        region -> dynamic([a], (is_nil(a.region) or a.region == ^region) and ^query)
      end

    matches = Osdi.Repo.all(from(a in Osdi.Address, where: ^query))

    existing =
      matches
      |> Enum.take(1)
      |> List.first()

    IO.inspect(existing)

    case existing do
      nil -> Osdi.Repo.insert!(address)
      found -> found
    end
  end

  def get_or_insert(address = %Osdi.Address{}) do
    address
  end

  def get_or_insert(address = %{}),
    do: Osdi.Address
        |> struct(address)
        |> get_or_insert()

  def update_coordinates(address = %Osdi.Address{id: _id}, {latitude, longitude}) do
    new_geo_point = %Geo.Point{coordinates: {latitude, longitude}, srid: nil}

    address
    |> change(%{location: new_geo_point})
    |> Osdi.Repo.update!()
  end
end
