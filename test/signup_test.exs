defmodule SignupTest do
  use ExUnit.Case

  test "standard email signup" do
    person = %Osdi.Person{}

    [first_name, last_name, email_chunk] =
      :alphanumeric
      |> StreamData.string()
      |> Stream.filter(fn str -> String.length(str) > 5 end)
      |> Enum.take(3)

    signup = Osdi.Person.signup_email(person,
      %{given_name: first_name, family_name: last_name,
        email: email_chunk <> "@comcast.edu"})

    assert {:ok, _person} = Osdi.Repo.insert(signup)
  end

  test "second email signup" do
    person = Osdi.Repo.all(Osdi.Person) |> List.first()

    %{given_name: first_name, family_name: last_name} = person

    [email_chunk] =
      :alphanumeric
      |> StreamData.string()
      |> Stream.filter(fn str -> String.length(str) > 5 end)
      |> Enum.take(1)

    signup = Osdi.Person.signup_email(person,
      %{given_name: first_name, family_name: last_name,
        email: email_chunk <> "@comcast.edu"})

    assert {:ok, %Osdi.Person{email_addresses: more_than_one}} = Osdi.Repo.update(signup)
    assert more_than_one |> length() > 1
  end
end
