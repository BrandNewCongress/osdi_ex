defmodule SignupTest do
  use ExUnit.Case
  alias Osdi.{Person, Repo}

  test "standard email signup" do
    person = %Person{}

    [first_name, last_name, email_chunk] =
      :alphanumeric
      |> StreamData.string()
      |> Stream.filter(fn str -> String.length(str) > 5 end)
      |> Enum.take(3)

    signup = Person.signup_email(person,
      %{given_name: first_name, family_name: last_name,
        email: email_chunk <> "@comcast.edu"})

    assert {:ok, _person} = Repo.insert(signup)
  end

  test "second email signup" do
    person = Repo.all(Person) |> List.first()

    %{given_name: first_name, family_name: last_name} = person

    [email_chunk] =
      :alphanumeric
      |> StreamData.string()
      |> Stream.filter(fn str -> String.length(str) > 5 end)
      |> Enum.take(1)

    signup = Person.signup_email(person,
      %{given_name: first_name, family_name: last_name,
        email: email_chunk <> "@comcast.edu"})

    assert {:ok, %Person{email_addresses: more_than_one}} = Repo.update(signup)
    assert more_than_one |> length() > 1
  end
end
