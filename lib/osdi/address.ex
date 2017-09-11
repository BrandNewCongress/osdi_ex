defmodule Osdi.Address do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  @base_attrs ~w(
    venue address_lines location locality region postal_code country
    time_zone location public
  )a

  schema "addresses" do
    field :venue, :string
    field :address_lines, {:array, :string}
    field :locality, :string
    field :region, :string
    field :postal_code, :string
    field :country, :string, default: "United States of America"
    field :time_zone, :string
    field :public, :boolean
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
      |> Map.take(~w(venue address_lines locality region postal_code country time_zone location public)a)
      |> Poison.Encoder.Map.encode(options)
    end
  end

  def changeset(address, params \\ %{}) do
    address
    |> cast(params, @base_attrs)
  end

  def get_or_insert(address = %Osdi.Address{address_lines: address_lines, locality: locality, region: region}) do
    address_line_zero = address_lines |> List.first()

    matches = Osdi.Repo.all(
      from a in Osdi.Address,
        where: ^address_line_zero in a.address_lines and
               a.locality == ^locality and
               a.region == ^region)

    existing =
      matches
      |> Enum.take(1)
      |> List.first()

    case existing do
      nil -> Osdi.Repo.insert!(address)
      found -> found
    end
  end

  def get_or_insert(_address = %Osdi.Address{}), do: %Osdi.Address{}
  def get_or_insert(_address = %{}), do: %{}
end
