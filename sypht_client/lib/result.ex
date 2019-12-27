defmodule SyphtClient.Result do
  @moduledoc """
  Retrieves OCR results from Sypht.
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
  Tries to get an OCR result from Sypht for file_id using access_token.
  Returns {:ok, decoded_json_response} if sucessful, {:error, reason_string} otherwise.
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
