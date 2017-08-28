defmodule Osdi.PhoneNumber do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :primary, :string
    field :number, :string
    field :extension, :string
    field :description, :string
    field :number_type, :string
    field :operator, :string
    field :country, :string
    field :sms_capable, :boolean
    field :do_not_call, :boolean
  end

  def changeset(email_address, params \\ %{}) do
    email_address
    |> cast(params, ~w(
        primary number extension description
        number_type operator country sms_capable do_not_call
       )a)
  end
end
