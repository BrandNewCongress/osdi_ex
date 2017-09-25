defmodule Osdi.ScriptQuestion do
  use Ecto.Schema
  import Ecto.Changeset

  @base_attrs ~w(identifiers sequence)a
  @associations ~w(question script)a

  @derive {Poison.Encoder, only: @base_attrs ++ @associations}
  schema "script_questions" do
    field :identifiers, {:array, :string}
    field :sequence, :integer

    belongs_to :question, Osdi.Question
    belongs_to :script, Osdi.Script

    timestamps()
  end

  def changeset(script_question, params \\ %{}) do
    script_question
    |> cast(params, @base_attrs)
    |> put_assoc(:question, params.question)
    |> put_assoc(:script, params.script)
  end
end
