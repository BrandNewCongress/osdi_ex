defmodule Osdi.Answer do
  use Ecto.Schema
  import Ecto.Changeset

  @base_attrs ~w(origin_system value responses)a
  @associations ~w(person question)a

  @derive {Poison.Encoder, only: @base_attrs ++ @associations}
  schema "answers" do
    field :identifiers, {:array, :string}
    field :origin_system, :string
    field :value, :string
    field :responses, {:array, :string}

    belongs_to :person, Osdi.Person
    belongs_to :question, Osdi.Question

    timestamps()
  end

  def changeset(answer, params \\ %{}) do
    answer
    |> cast(params, @base_attrs)
    |> put_assoc(:person, params.person)
    |> put_assoc(:question, params.question)
  end
end
