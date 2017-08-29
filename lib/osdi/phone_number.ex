defmodule Osdi.PhoneNumber do
  use Ecto.Schema
  import Ecto.Changeset
  alias Osdi.{Repo}

  @base_attrs ~w(
    primary number extension description number_type operator
    country sms_capable do_not_call
  )a

  schema "phone_numbers" do
    field :primary, :string
    field :number, :string
    field :extension, :string
    field :description, :string
    field :number_type, :string
    field :operator, :string
    field :country, :string
    field :sms_capable, :boolean
    field :do_not_call, :boolean

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
        on_conflict: [set:
          [primary: phone_number.primary,
           sms_capable: phone_number.sms_capable,
           do_not_call: phone_number.do_not_call]],
        conflict_target: [:primary, :sms_capable, :do_not_call])
  end
end
