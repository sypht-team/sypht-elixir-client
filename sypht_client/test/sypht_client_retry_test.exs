defmodule SyphtClient.RetryTest do
  use ExUnit.Case
  doctest SyphtClient.Retry

  defp backoff_state() do
    %{
      retry_on: [500],
      waited: 0,
      retry_until: 300,
      next_backoff: 100
    }
  end

  test "handles success on a single pass" do
    fnOk = fn -> {:ok, %HTTPoison.Response{status_code: 200, body: "OK"}} end
    assert SyphtClient.Retry.http(fnOk, backoff_state()) == {:ok, "OK"}
  end

  test "handles failure on a non-retry response" do
    fnJustFail = fn -> {:ok, %HTTPoison.Response{status_code: 400, body: "FUBAR"}} end
    assert SyphtClient.Retry.http(fnJustFail, backoff_state()) == {:error, 400, "FUBAR"}
  end

  test "handles failure on a retry response" do
    fnJustFail = fn -> {:ok, %HTTPoison.Response{status_code: 500, body: "SNAFU"}} end
    assert SyphtClient.Retry.http(fnJustFail, backoff_state()) == {:error, 500, "SNAFU"}
  end

  test "handles a non-HTTP failure" do
    fnClientFail = fn -> {:error, %HTTPoison.Error{reason: :uwot}} end
    assert SyphtClient.Retry.http(fnClientFail, backoff_state()) == {:error, :uwot}
  end
end
