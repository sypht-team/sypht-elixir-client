defmodule SyphtClient.Auth do
  @moduledoc """
  Acquires and caches Sypht access tokens.

  ## Configuration

  Override these defaults in the `:sypht_client` section of your config.exs files.

  * `auth_url: "https://login.sypht.com/oauth/token"` - URL of token acquisition end point
  * `auth_ttl: 84_600_000` - Token TTL milliseconds. Sypht tokens last for 24 hours - reacquire after 23 hours 30 minutes
  * `auth_retry_on: [500]` - Retry token acquisition on server HTTP status
  * `auth_initial_backoff: 200` - Initial backoff milliseconds
  * `auth_retry_until: 30_000` - Continue backing off and retrying until this many milliseconds have elapsed
  * `auth_http_options: [ssl: [{:versions, [:"tlsv1.2"]}]]` - Hackney HTTP options for authentication
  * `auth_error_prefix: "SyphtAuth failed:"` - Prefix authentication error messages with this
  """
  @cache_name :token_cache
  @token_cache_key :sypht_access_token

  @doc """
  Gets and caches an access token using the client ID and secret in the environment variable SYPHT_API_KEY.
  Returns {:ok, sypht_bearer_token} if successful, {:error, reason_string} otherwise. 
  """
  def access_token() do
    case Cachex.get(@cache_name, @token_cache_key) do
      {:ok, nil} ->
        case SyphtClient.Retry.post(http_args(), backoff_args()) do
          {:ok, response} ->
            response_body = Jason.decode!(response)
            access_token = response_body["access_token"]
            cache_put(access_token)

            {:ok, access_token}

          {:error, status, reason} ->
            {:error,
             SyphtClient.Error.message(
               Application.get_env(:sypht_client, :auth_error_prefix),
               status,
               reason
             )}

          {:error, reason} ->
            {:error,
             SyphtClient.Error.message(
               Application.get_env(:sypht_client, :auth_error_prefix),
               reason
             )}
        end

      {:ok, access_token} ->
        {:ok, access_token}
    end
  end

  defp http_args() do
    id_secret = String.split(System.get_env("SYPHT_API_KEY"), ":", parts: 2)

    %{
      url: Application.get_env(:sypht_client, :auth_url),
      options: Application.get_env(:sypht_client, :auth_http_options),
      headers: [{"Content-Type", "application/json"}],
      payload:
        Jason.encode!(%{
          client_id: List.first(id_secret),
          client_secret: List.last(id_secret),
          audience: "https://api.sypht.com",
          grant_type: "client_credentials"
        })
    }
  end

  defp backoff_args() do
    %{
      initial_backoff: Application.get_env(:sypht_client, :auth_initial_backoff),
      retry_until: Application.get_env(:sypht_client, :auth_retry_until),
      retry_on: Application.get_env(:sypht_client, :auth_retry_on)
    }
  end

  defp cache_put(access_token) do
    Cachex.put(
      @cache_name,
      @token_cache_key,
      access_token,
      ttl: Application.get_env(:sypht_client, :auth_ttl)
    )
  end
end
