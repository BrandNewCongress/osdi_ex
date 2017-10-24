defmodule Osdi.Question do
  use Ecto.Schema
  import Ecto.Changeset

  @base_attrs ~w(identifiers origin_system title description summary question_type)a
  @associations ~w(creator modified_by)a

  @derive {Poison.Encoder, only: @base_attrs ++ @associations}
  schema "questions" do
    field(:identifiers, {:array, :string})
    field(:origin_system, :string)
    field(:title, :string)
    field(:description, :string)
    field(:summary, :string)
    field(:question_type, :string)

    embeds_many(:responses, Osdi.Response)

    belongs_to(:creator, Osdi.Person)
    belongs_to(:modified_by, Osdi.Person)

    has_many(:answers, Osdi.Answer)

    timestamps()
  end

  def changeset(question, params \\ %{}) do
    question
    |> cast(params, @base_attrs)
    |> put_assoc(:creator, params.creator)
    |> put_assoc(:modified_by, params.modified_by)
  end
end
