defmodule Osdi.Script do
  use Ecto.Schema
  import Ecto.Changeset

  @base_attrs ~w(identifiers origin_system title description summary)a
  @associations ~w(creator modified_by script_questions)a

  @derive {Poison.Encoder, only: @base_attrs ++ @associations}
  schema "scripts" do
    field :identifiers, {:array, :string}
    field :origin_sytem, :string
    field :title, :string
    field :description, :string
    field :summary, :string

    belongs_to :creator, Osdi.Person
    belongs_to :modified_by, Osdi.Person

    has_many :script_questions, Osdi.ScriptQuestion

    timestamps()
  end

  def changeset(script, params \\ %{}) do
    script
    |> cast(params, @base_attrs)
    |> put_assoc(:creator, params.creator)
    |> put_assoc(:modified_by, params.modified_by)
    |> put_assoc(:script_questions, params.script_questions)
  end
end
