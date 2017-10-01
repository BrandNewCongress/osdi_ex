defmodule Osdi.Tag do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Osdi.{Repo}

  @base_attrs ~w(name origin_system description)a

  @derive {Poison.Encoder, only: @base_attrs}
  schema "tags" do
    field :name, :string
    field :origin_system, :string
    field :description, :string

    has_many :taggings, Osdi.Tagging
    many_to_many :people, Osdi.Person, join_through: Osdi.Tagging

    timestamps()
  end

  def changeset(tag, params \\ %{}) do
    tag
    |> cast(params, @base_attrs)
    |> unique_constraint(:name)
    |> validate_required([:name])
  end

  def get_or_insert(_tag = %{name: name}) do
    get_or_insert(name)
  end

  def get_or_insert(name) do
    Repo.insert! %Osdi.Tag{name: name},
      on_conflict: [set: [name: name]],
      conflict_target: :name
  end

  def get_or_insert_all(tags) do
    if tags |> List.first() |> is_binary() do
      as_maps = Enum.map tags, &(%{name: &1, inserted_at: Timex.now(), updated_at: Timex.now()})
      Repo.insert_all Osdi.Tag, as_maps, on_conflict: :nothing
      Repo.all from t in Osdi.Tag, where: t.name in ^tags
    else
      name_list = Enum.map tags, &(&1.name)
      Repo.insert_all Osdi.Tag, tags, on_conflict: :nothing
      Repo.all from t in Osdi.Tag, where: t.name in ^name_list
    end
  end

  def ensure(tag_string) do
    query = from t in Osdi.Tag, where: t.name == ^tag_string

    case Repo.one(query) do
      nil ->
        %Osdi.Tag{name: tag_string, origin_system: "osdi"}
        |> Repo.insert()
        |> Tuple.to_list()
        |> List.last()

      tag -> tag
    end
  end
end
