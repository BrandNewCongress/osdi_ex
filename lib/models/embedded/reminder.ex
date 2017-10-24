defmodule Osdi.Reminder do
  use Ecto.Schema

  embedded_schema do
    field(:method, :string)
    field(:minutes, :float)
  end
end
