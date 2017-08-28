defmodule Osdi.ReferrerData do
  use Ecto.Schema

  embedded_schema do
    field :source,	:string
    field :referrer,	:string
    field :website,	:string
    field :url,	:string
  end

  def changeset(referrer_data, params \\ %{}) do
    referrer_data
    |> Ecto.Changeset.cast(params, ~w(source referrer website url))
  end
end
