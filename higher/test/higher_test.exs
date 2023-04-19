defmodule HigherTest do
  use ExUnit.Case
  doctest Higher

  test "greets the world" do
    assert Higher.hello() == :world
  end
end
