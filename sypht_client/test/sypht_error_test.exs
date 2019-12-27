defmodule SyphtErrorTest do
  use ExUnit.Case
  doctest SyphtError

  test "handles a nil reason" do
    assert SyphtError.message("prefix", 200, nil) == "prefix HTTP 200"
  end

  test "handles an empty reason" do
    assert SyphtError.message("prefix", 200, "") == "prefix HTTP 200"
  end

  test "handles a simple reason" do
    assert SyphtError.message("prefix", 500, "FUBAR\n") == "prefix HTTP 500 -> FUBAR\n"
  end

  test "handles a Sypht error message" do
    assert SyphtError.message("prefix", 400, "{\"message\":\"FUBAR\"}") ==
             "prefix HTTP 400 -> FUBAR"
  end

  test "handles some other JSON response" do
    assert SyphtError.message("prefix", 400, "{\"unexpected\":\"FUBAR\"}") ==
             "prefix HTTP 400 -> {\"unexpected\":\"FUBAR\"}"
  end
end
