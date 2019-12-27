defmodule SyphtClient.Upload do
  @moduledoc """
  Uploads files to Sypht.
  """
  @url Application.get_env(:sypht_client, :upload_url)
  @http_options Application.get_env(:sypht_client, :upload_http_options)
  @headers [{"Content-Type", "multipart/form-data"}]
  @field_set_part {
    "",
    Jason.encode!(Application.get_env(:sypht_client, :upload_field_sets)),
    {"form-data", [{"name", "fieldSets"}]},
    [{"content-type", "application/json"}]
  }
  @backoff_args %{
    initial_backoff: Application.get_env(:sypht_client, :upload_initial_backoff),
    retry_until: Application.get_env(:sypht_client, :upload_retry_until),
    retry_on: Application.get_env(:sypht_client, :upload_retry_on)
  }
  @error_prefix Application.get_env(:sypht_client, :upload_error_prefix)

  @doc """
  Uploads the file at path to Sypht using access_token. 
  Returns {:ok, file_id} if successful, {:error, reason_string} otherwise.
  """
  def file(access_token, path) do
    form_data = {"form-data", [{"name", "fileToUpload"}, {"filename", Path.basename(path)}]}

    payload = {
      :multipart,
      [
        {:file, path, form_data, []},
        @field_set_part
      ]
    }

    headers = [{"Authorization", "Bearer #{access_token}"} | @headers]

    case SyphtClient.Retry.post(http_args(headers, payload), @backoff_args) do
      {:ok, response} ->
        response_body = Jason.decode!(response)
        {:ok, response_body["fileId"]}

      {:error, status, message} ->
        {:error, SyphtClient.Error.message(@error_prefix, status, message)}

      {:error, reason} ->
        {:error, SyphtClient.Error.message(@error_prefix, reason)}
    end
  end

  defp http_args(headers, payload) do
    %{
      url: @url,
      options: @http_options,
      headers: headers,
      payload: payload
    }
  end
end