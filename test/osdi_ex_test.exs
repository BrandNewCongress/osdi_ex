defmodule OsdiTest do
  use ExUnit.Case

  test "creates a person" do
    assert Osdi.hello() == :world
  end
end
