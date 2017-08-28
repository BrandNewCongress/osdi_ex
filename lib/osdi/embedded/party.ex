defmodule Osdi.Party do
  use Ecto.Schema

  embedded_schema do
    field :identification, :string
    field :last_verified_date, :utc_datetime
    field :active, :boolean
  end
end
