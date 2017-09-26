defmodule Osdi.PhoneNumber do
  use Ecto.Schema
  import Ecto.Changeset
  alias Osdi.{Repo}

  @base_attrs ~w(
    primary number extension description number_type operator
    country sms_capable do_not_call
  )a

  @derive {Poison.Encoder, only: @base_attrs}
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
    field :twilio_lookup_result, :map

    many_to_many :people, Osdi.Person, join_through: "people_phones"

    timestamps()
  end

  def changeset(phone_number, params \\ %{}) do
    phone_number
    |> cast(params, @base_attrs)
  end

  def get_or_insert(phone_number = %Osdi.PhoneNumber{}) do
    phone_number
    |> Map.take(@base_attrs)
    |> (fn pn -> struct(Osdi.PhoneNumber, pn) end).()
    |> Repo.insert!(
      on_conflict: [set:
        phone_number
        |> Map.from_struct()
        |> Map.take(~w(do_not_call sms_capable twilio_lookup_result)a)
        |> Enum.filter(fn {_key, value} -> value != nil end)
        |> Enum.into([number: phone_number.number])
      ],
      conflict_target: :number)
  end

  def get_or_insert(phone_number) do
    Osdi.PhoneNumber
    |> struct(phone_number)
    |> get_or_insert()
  end
end
