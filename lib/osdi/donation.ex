defmodule Osdi.Donation do
  use Ecto.Schema

  schema "donations" do
    field :origin_system, :string
    field :action_date, :utc_datetime
    field :amount, :float
    field :voided, :boolean
    field :voided_date, :utc_datetime
    field :url, :string

    embeds_one :payment, Osdi.Payment

    embeds_one :referrer_data, Osdi.ReferrerData
    embeds_many :recipients, Osdi.Recipient

    belongs_to :person, Osdi.Person

    timestamps()
  end

  def changeset(donation, params \\ %{}) do
    donation
    |> Ecto.Changeset.cast(params, [:origin_system, :action_date, :amount])
    |> Ecto.Changeset.cast_embed(:payment)
    |> Ecto.Changeset.cast_embed(:recipients)
    |> Ecto.Changeset.cast_embed(:referrer_data)
    |> Ecto.Changeset.put_assoc(:person, params.person)
    |> Ecto.Changeset.validate_required([:origin_system, :action_date, :amount, :recipients, :person])
  end
end
