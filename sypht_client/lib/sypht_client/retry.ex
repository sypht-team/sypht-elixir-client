defmodule SyphtClient.Retry do
  @moduledoc false

  use Bitwise

  def post(http_args, backoff_args) do
    http(
      fn ->
        HTTPoison.post(
          http_args[:url],
          http_args[:payload],
          http_args[:headers],
          http_args[:options]
        )
      end,
      init_backoff_state(backoff_args)
    )
  end

  def get(http_args, backoff_args) do
    http(
      fn ->
        HTTPoison.get(
          http_args[:url],
          http_args[:headers],
          http_args[:options]
        )
      end,
      init_backoff_state(backoff_args)
    )
  end

  defp init_backoff_state(backoff_args) do
    %{
      retry_on: backoff_args[:retry_on],
      waited: 0,
      retry_until: backoff_args[:retry_until],
      next_backoff: backoff_args[:initial_backoff]
    }
  end

  def http(method, backoff_state) do
    case method.() do
      {:ok, %HTTPoison.Response{status_code: status, body: body}} when status in [200, 201] ->
        {:ok, body}

      {:ok, %HTTPoison.Response{status_code: status, body: body}} ->
        if retry?(status, backoff_state) do
          retry(method, backoff_state)
        else
          {:error, status, body}
        end

      {:ok, %HTTPoison.Response{status_code: status}} ->
        if retry?(status, backoff_state) do
          retry(method, backoff_state)
        else
          {:error, status}
        end

      {:error, %HTTPoison.Error{reason: reason}} ->
        if retry?(backoff_state) do
          retry(method, backoff_state)
        else
          {:error, reason}
        end
    end
  end

  defp retry?(backoff_state) do
    backoff_state[:waited] >= backoff_state[:backoff_until]
  end

  defp retry?(status, backoff_state) do
    Enum.member?(backoff_state[:retry_on], status) and retry?(backoff_state)
  end

  defp retry(method, backoff_state) do
    :timer.sleep(backoff_state[:next_backoff])

    http(
      method,
      %{
        backoff_state
        | waited: backoff_state[:waited] + backoff_state[:next_backoff],
          next_backoff: backoff_state[:next_backoff] <<< 1
      }
    )
  end
end
