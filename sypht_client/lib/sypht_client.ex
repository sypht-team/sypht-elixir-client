defmodule SyphtClient do
  @moduledoc """
  Demonstrates the Sypht API document workflow. 
  Parsing Sypht API results is beyond the scope of this client. 
  See https://docs.sypht.com/ for details.
  """

  @doc """
  Send the file at path to Sypht. Returns {:ok, decoded_sypht_api_response} if successful, 
  {:error, reason_string} otherwise. This is a potentially long-running method: 
  execute asynchronously.
  """
  def send(path) do
    with {:ok, access_token} <- SyphtClient.Auth.access_token(),
         {:ok, file_id} <- SyphtClient.Upload.file(access_token, path),
         {:ok, result} <- SyphtClient.Result.get(access_token, file_id) do
      {:ok, result}
    else
      {:error, reason} -> {:error, reason}
      _ -> {:error, "Unspecified failure"}
    end
  end
end
