defmodule Osdi.EmailAddress do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :primary, :boolean
    field :address, :string
    field :address_type, :string
    field :status, :string
  end

  def changeset(email_address, params \\ %{}) do
    email_address
    |> cast(params, [:primary, :address, :address_type, :status])
  end
end
