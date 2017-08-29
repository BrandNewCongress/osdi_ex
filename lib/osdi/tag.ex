defmodule Osdi.Tag do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Osdi.{Repo}

  schema "tags" do
    field :name, :string
    field :origin_system, :string
    field :description, :string

    has_many :taggings, Osdi.Tagging

    timestamps()
  end

  def changeset(tag, params \\ %{}) do
    tag
    |> cast(params, [:name, :origin_system, :description])
    |> unique_constraint(:name)
    |> validate_required([:name])
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
