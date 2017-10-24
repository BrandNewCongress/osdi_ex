defmodule Osdi.Payment do
  use Ecto.Schema

  embedded_schema do
    field(:method, :string)
    field(:reference_number, :string)
    field(:authorization_stored, :boolean)
  end
end
