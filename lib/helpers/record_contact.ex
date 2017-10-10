defmodule Osdi.RecordContact do
  alias Osdi.{Repo, Contact, Person}

  # Only contact is required / respected
  # Partial implementation
  def main(helper_body = %{contact: contact}) do
    params =
      contact
      |> Map.put(:target, %Person{id: contact.target})
      |> Map.put(:contactor, %Person{id: contact.contactor})

    contact =
      %Contact{}
      |> Contact.changeset(params)
      |> Repo.insert!()
  end
end
