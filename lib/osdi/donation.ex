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

    belongs_to :person, Osdi.Person

    timestamps()
  end

  def add(donation, params \\ %{}) do
    donation
    |> Ecto.Changeset.cast(params, [:origin_system, :action_date, :amount, :recipients, :referrer_data])
    |> Ecto.Changeset.put_assoc(:person, params.person)
    |> Ecto.Changeset.validate_required([:origin_system, :action_date, :amount, :recipients, :person])
  end
end
