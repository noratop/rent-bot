defmodule TestQuantumTest do
  use ExUnit.Case
  doctest TestQuantum

  test "greets the world" do
    assert TestQuantum.hello() == :world
  end
end
