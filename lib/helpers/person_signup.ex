defmodule Osdi.PersonSignup do
  alias Osdi.{Person}

  # Only person is required
  # Partial implementation
  def main(helper_body = %{person: person}) do
    p = Person.push(person)
    p = case helper_body do
      %{add_tags: tags} -> Person.add_tags(p, tags)
      %{} -> p
    end
    p
  end
end
