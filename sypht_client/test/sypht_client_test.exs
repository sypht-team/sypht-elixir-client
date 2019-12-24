defmodule SyphtClientTest do
  use ExUnit.Case
  doctest SyphtClient

  test "greets the world" do
    assert SyphtClient.hello() == :world
  end
end
