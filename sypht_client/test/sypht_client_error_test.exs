defmodule SyphtClient.ErrorTest do
  use ExUnit.Case
  doctest SyphtClient.Error

  test "handles a nil reason" do
    assert SyphtClient.Error.message("prefix", 200, nil) == "prefix HTTP 200"
  end

  test "handles an empty reason" do
    assert SyphtClient.Error.message("prefix", 200, "") == "prefix HTTP 200"
  end

  test "handles a simple reason" do
    assert SyphtClient.Error.message("prefix", 500, "FUBAR\n") == "prefix HTTP 500 -> FUBAR\n"
  end

  test "handles a Sypht error message" do
    assert SyphtClient.Error.message("prefix", 400, "{\"message\":\"FUBAR\"}") ==
             "prefix HTTP 400 -> FUBAR"
  end

  test "handles some other JSON response" do
    assert SyphtClient.Error.message("prefix", 400, "{\"unexpected\":\"FUBAR\"}") ==
             "prefix HTTP 400 -> {\"unexpected\":\"FUBAR\"}"
  end
end
