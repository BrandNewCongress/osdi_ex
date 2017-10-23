defmodule Osdi.RecordContact do
  alias Osdi.{Repo, Contact}

  # Only contact is required / respected
  # Partial implementation
  def main(_helper_body = %{contact: contact}) do
    with_assocs =
      contact
      |> Map.put(:target_id, as_id(contact.target))
      |> Map.put(:contactor_id, as_id(contact.contactor))
      |> Map.drop([:target, :contactor])

    as_struct = struct(Contact, with_assocs)
    Repo.insert!(as_struct)
  end

  defp as_id(value) do
    case Ecto.Type.cast(:id, value) do
      {:ok, id} -> id
      other -> other
    end
  end
end
