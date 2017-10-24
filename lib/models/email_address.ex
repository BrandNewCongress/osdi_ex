defmodule Osdi.EmailAddress do
  use Ecto.Schema
  import Ecto.Changeset
  alias Osdi.{Repo}

  @base_attrs ~w(primary address address_type status)a

  @derive {Poison.Encoder, only: @base_attrs}
  schema "email_addresses" do
    field(:primary, :boolean)
    field(:address, :string)
    field(:address_type, :string)
    field(:status, :string, default: "subscribed")

    many_to_many(:people, Osdi.Person, join_through: "people_emails")

    timestamps()
  end

  def changeset(email_address, params \\ %{}) do
    email_address
    |> unique_constraint(:address)
    |> cast(params, @base_attrs)
  end

  def get_or_insert(email_address = %Osdi.EmailAddress{}) do
    email_address
    |> Map.take(@base_attrs)
    |> (fn pn -> struct(Osdi.EmailAddress, pn) end).()
    |> Repo.insert!(
         on_conflict: [set: [address: email_address.address]],
         conflict_target: :address
       )
  end

  def get_or_insert(email_address) do
    Osdi.EmailAddress
    |> struct(email_address)
    |> get_or_insert()
  end
end
