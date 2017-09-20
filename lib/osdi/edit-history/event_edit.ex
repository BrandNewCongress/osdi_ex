defmodule Osdi.EventEdit do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Osdi.{Repo}

  @base_attrs ~w(actor edits edited)a

  @derive {Poison.Encoder, only: @base_attrs}
  schema "admin_history" do
    field :actor, :string
    field :edit, :map

    belongs_to :event, Osdi.Event

    timestamps()
  end

  def edits_by_within_for(actor, duration = %Timex.Duration{}, event_id) do
    since = Timex.now() |> Timex.subtract(duration)

    Repo.all(from ee in Osdi.EventEdit,
      where: ee.actor == ^actor
        and ee.inserted_at > ^since
        and ee.event_id == ^event_id,
      select: ee.edit)
  end
end
