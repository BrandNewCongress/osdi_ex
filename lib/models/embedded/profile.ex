defmodule Osdi.Profile do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field(:provider, :string)
    field(:url, :string)
    field(:handle, :string)
  end

  def changeset(profile, params \\ %{}) do
    profile
    |> cast(params, [:provider, :url, :handle])
  end
end
