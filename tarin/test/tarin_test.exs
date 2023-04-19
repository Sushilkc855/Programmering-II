defmodule TarinTest do
  use ExUnit.Case
  doctest Tarin

  test "greets the world" do
    assert Tarin.hello() == :world
  end
end
