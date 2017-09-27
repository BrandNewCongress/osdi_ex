defmodule Osdi.PersonEdit do
  use Ecto.Schema
  import Ecto.Query
  alias Osdi.{Repo}

  @base_attrs ~w(actor edits edited)a

  @derive {Poison.Encoder, only: @base_attrs}
  schema "admin_history" do
    field :actor, :string
    field :edit, :map

    belongs_to :person, Osdi.Person

    timestamps()
  end

  def edits_by_within_for(actor, duration = %Timex.Duration{}, person_id) do
    since = Timex.now() |> Timex.subtract(duration)

    Repo.all(from pe in Osdi.PersonEdit,
      where: pe.actor == ^actor
        and pe.inserted_at > ^since
        and pe.person_id == ^person_id,
      select: pe.edit)
  end
end
