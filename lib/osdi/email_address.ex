defmodule Osdi.EmailAddress do
  use Ecto.Schema
  import Ecto.Changeset
  alias Osdi.{Repo}

  @base_attrs ~w(primary address address_type status)a

  schema "email_addresses" do
    field :primary, :boolean
    field :address, :string
    field :address_type, :string
    field :status, :string

    belongs_to :person, Osdi.Person
  end

  def changeset(email_address, params \\ %{}) do
    email_address
    |> cast(params, @base_attrs)
  end

  def get_or_insert(email_address) do
    Osdi.EmailAddress
    |> struct(email_address)
    |> Repo.insert!(
        on_conflict: [set: [primary: email_address.primary, status: email_address.status]],
        conflict_target: [:primary, :status])
  end
end
