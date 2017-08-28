defmodule Osdi.PhoneNumber do
  use Ecto.Schema

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
end
