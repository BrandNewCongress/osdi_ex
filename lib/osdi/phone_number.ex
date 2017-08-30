defmodule Osdi.PhoneNumber do
  use Ecto.Schema
  import Ecto.Changeset
  alias Osdi.{Repo}

  @base_attrs ~w(
    primary number extension description number_type operator
    country sms_capable do_not_call
  )a

  schema "phone_numbers" do
    field :primary, :boolean
    field :number, :string
    field :extension, :string
    field :description, :string
    field :number_type, :string
    field :operator, :string
    field :country, :string
    field :sms_capable, :boolean
    field :do_not_call, :boolean

    many_to_many :people, Osdi.Person, join_through: "people_phones"

    timestamps()
  end

  def changeset(phone_number, params \\ %{}) do
    phone_number
    |> cast(params, @base_attrs)
  end

  def get_or_insert(phone_number) do
    Osdi.PhoneNumber
    |> struct(phone_number)
    |> Repo.insert!(
        on_conflict: [set: Enum.into(phone_number, [])],
        conflict_target: :number)
  end
end
