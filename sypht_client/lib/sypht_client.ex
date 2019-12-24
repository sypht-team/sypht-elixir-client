defmodule SyphtClient do
  @moduledoc """
  Demonstrates the Sypht document workflow. 
  Uses Jason for JSON parsing and the HTTPoison client. 
  See https://docs.sypht.com/
  """

  @doc """
  Sends file_path to Sypht. Returns {:ok, decoded_sypht_api_response} if successful, 
  {:error, reason_string} otherwise. This is a potentially long-running method: 
  execute asynchronously.
  """
  def send(file_path) do
    with {:ok, access_token} <- SyphtAuth.access_token(),
         {:ok, file_id} <- SyphtUpload.send(access_token, file_path),
         {:ok, result} <- SyphtResult.get(access_token, file_id) do
      {:ok, result}
    else
      {:error, reason} -> {:error, reason}
      _ -> {:error, "Unspecified failure"}
    end
  end
end
