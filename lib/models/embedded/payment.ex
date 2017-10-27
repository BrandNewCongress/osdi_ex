defmodule Osdi.Payment do
  use Ecto.Schema

  @base_attrs ~w(method reference_number authorization_stored)a

  embedded_schema do
    field(:method, :string)
    field(:reference_number, :string)
    field(:authorization_stored, :boolean)
  end

  def changeset(payment, params \\ %{}) do
    payment
    |> cast(params, @base_attrs)
  end
end
