defmodule Osdi.RecordContact do
  alias Osdi.{Repo, Contact, Person}

  # Only contact is required / respected
  # Partial implementation
  def main(helper_body = %{contact: contact}) do
    with_assocs =
      contact
      |> Map.put(:target_id, contact.target)
      |> Map.put(:contactor_id, contact.contactor)
      |> Map.drop([:target, :contactor])

    as_struct = struct(Contact, with_assocs)
    Repo.insert!(as_struct)
  end
end
