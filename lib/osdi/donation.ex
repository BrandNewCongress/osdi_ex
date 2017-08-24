defmodule Osdi.Donation do
  use Ecto.Schema

  schema "donations" do
    field :origin_system, :string
    field :action_date, :utc_datetime
    field :amount, :float
    field :recipients, {:array, :map}
    field :payment, :map
    field :voided, :boolean
    field :voided_date, :utc_datetime
    field :url, :string
    field :referrer_data, :map
  end
end
