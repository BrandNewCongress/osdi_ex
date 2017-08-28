defmodule Osdi.Recipient do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :display_name, :string
    field :legal_name, :string
    field :amount, :float
  end

  def changeset(recipient, params \\ %{}) do
    recipient
    |> cast(params, [:display_name, :legal_name, :amount])
  end
end
