defmodule Osdi.Contact do
  use Ecto.Schema
  import Ecto.Changeset

  @base_attrs ~w(origin_system action_date contact_type input_type success status_code)a
  @associations ~w(target contactor)a

  @derive {Poison.Encoder, only: @base_attrs ++ @associations}
  schema "contacts" do
    field :identifiers, {:array, :string}
    field :origin_system, :string
    field :action_date, :utc_datetime
    field :contact_type, :string
    field :input_type, :string
    field :success, :boolean
    field :status_code, :string

    belongs_to :target, Osdi.Person
    belongs_to :contactor, Osdi.Person

    timestamps()
  end

  def changeset(contact, params \\ %{}) do
    contact
    |> cast(params, @base_attrs)
    |> put_assoc(:target, params.target)
    |> put_assoc(:contactor, params.contactor)
  end
end
