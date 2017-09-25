defmodule Osdi.ContactEffort do
  use Ecto.Schema
  import Ecto.Changeset

  @base_attrs ~w(identifiers origin_system name title description summary start_date end_date type)a
  @associations ~w(creator modified_by contacts script)a

  @derive {Poison.Encoder, only: @base_attrs ++ @associations}
  schema "contacts" do
    field :identifiers, {:array, :string}
    field :origin_sytem, :string
    field :name, :string
    field :title, :string
    field :description, :text
    field :summary, :text
    field :start_date, :utc_datetime
    field :end_date, :utc_datetime
    field :type, :string

    belongs_to :creator, Osdi.Person
    belongs_to :modified_by, Osdi.Person

    has_many :contacts, Osdi.Contacts
    has_one :script, Osdi.Script

    timestamps()
  end

  def changeset(contact_effort, params \\ %{}) do
    contact_effort
    |> cast(params, @base_attrs)
    |> put_assoc(:creator, params.creator)
    |> put_assoc(:modified_by, params.modified_by)
    |> put_assoc(:contacts, params.contacts)
    |> put_assoc(:script, params.script)
  end
end
