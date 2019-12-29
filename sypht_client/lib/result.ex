defmodule SyphtClient.Result do
  @moduledoc """
  Gets OCR results from Sypht.

  ## Module properties

  Override these defaults in the `:sypht_client` section of your config.exs files.

  * `result_url: "https://api.sypht.com/result/final"` - URL of result end point
  * `result_retry_on: [202, 500]` - Retry result requests on server HTTP status
  * `result_initial_backoff: 200` - Initial backoff milliseconds
  * `result_retry_until: 300_000` - Continue backing off and retrying until this many milliseconds have elapsed
  * `result_http_options: [
    timeout: 20_000,
    recv_timeout: 150_000,
    ssl: [{:versions, [:"tlsv1.2"]}]
  ]` - Hackney HTTP options for results
  * `result_error_prefix: "SyphtResult failed:"` - Prefix result error messages with this
  """
  @url Application.get_env(:sypht_client, :result_url)
  @http_options Application.get_env(:sypht_client, :result_http_options)
  @backoff_args %{
    initial_backoff: Application.get_env(:sypht_client, :result_initial_backoff),
    retry_until: Application.get_env(:sypht_client, :result_retry_until),
    retry_on: Application.get_env(:sypht_client, :result_retry_on)
  }
  @error_prefix Application.get_env(:sypht_client, :result_error_prefix)

  @doc """
  Gets an OCR result from Sypht for file_id using access_token.
  Returns {:ok, decoded_json_response} if successful, {:error, reason_string} otherwise.
  """
  def get(access_token, file_id) do
    case SyphtClient.Retry.get(http_args(access_token, file_id), @backoff_args) do
      {:ok, response} ->
        {:ok, Jason.decode!(response)}

      {:error, status, reason} ->
        {:error, SyphtClient.Error.message(@error_prefix, status, reason)}

      {:error, reason} ->
        {:error, SyphtClient.Error.message(@error_prefix, reason)}
    end
  end

  defp http_args(access_token, file_id) do
    %{
      url: "#{@url}/#{file_id}",
      options: @http_options,
      headers: [{"Authorization", "Bearer #{access_token}"}]
    }
  end
end
