defmodule Osdi.Donation do
  use Ecto.Schema
  import Ecto.Changeset

  @base_attrs ~w(identifiers origin_system action_date amount voided voided_date url)a
  @associations ~w(payment referrer_data recipients person)a

  @derive {Poison.Encoder, only: @base_attrs ++ @associations}
  schema "donations" do
    field :identifiers, {:array, :string}
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
    |> cast(params, @base_attrs)
    |> cast_embed(:payment)
    |> cast_embed(:recipients)
    |> cast_embed(:referrer_data)
    |> put_assoc(:person, params.person)
  end
end
