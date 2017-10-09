defmodule Osdi.ContactInfo do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :name, :string
    field :phone_number, :string
    field :email_address, :string
    field :additional_info, :string
    field :public, :boolean, default: true
  end

  def changeset(contact, params \\ %{}) do
    contact
    |> cast(params, [:name, :phone_number, :email_address, :public])
  end
end
