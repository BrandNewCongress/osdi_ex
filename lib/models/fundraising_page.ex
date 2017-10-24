defmodule Osdi.FundraisingPage do
  use Ecto.Schema
  import Ecto.Changeset

  @base_attrs ~w(identifiers origin_system name title description summary browser_url administrative_url featured_image_url currency share_url)a

  @derive {Poison.Encoder, only: @base_attrs}
  schema "fundraising_pages" do
    field(:identifiers, {:array, :string})
    field(:origin_system, :string)
    field(:name, :string)
    field(:title, :string)
    field(:description, :string)
    field(:summary, :string)
    field(:browser_url, :string)
    field(:administrative_url, :string)
    field(:featured_image_url, :string)
    field(:currency, :string)
    field(:share_url, :string)

    has_many(:donations, Osdi.Donation)

    timestamps()
  end

  def changeset(fundraising_page, params \\ %{}) do
    fundraising_page
    |> cast(params, @base_attrs)
  end
end
