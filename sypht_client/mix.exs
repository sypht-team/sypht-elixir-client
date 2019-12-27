defmodule SyphtClient.MixProject do
  use Mix.Project

  def project do
    [
      app: :sypht_client,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [],
      env: [
        # URL of token acquisition end point
        auth_url: "https://login.sypht.com/oauth/token",
        # Token TTL. Sypht tokens last for 24 hours - reacquire after 23 hours 30 minutes
        auth_ttl: 84_600_000,
        # Retry token acquisition on server HTTP status
        auth_retry_on: [500],
        # Initial backoff milliseconds
        auth_initial_backoff: 200,
        # Continue backing off and retrying token acquisition for this many milliseconds
        auth_retry_until: 30_000,
        # Hackney HTTP options for authentication
        auth_http_options: [ssl: [{:versions, [:"tlsv1.2"]}]],
        # Prefix authentication error messages with this
        auth_error_prefix: "SyphtAuth failed:",
        # URL of file upload end point
        upload_url: "https://api.sypht.com/fileupload",
        # Sypht field set(s) to invoke (see )
        upload_field_sets: ["sypht.generic"],
        # Retry uploads on server HTTP status
        upload_retry_on: [500],
        # Initial backoff milliseconds
        upload_initial_backoff: 200,
        # Continue backing off and retrying uploads for this many milliseconds
        upload_retry_until: 60_000,
        # Hackney HTTP options for uploads
        upload_http_options: [ssl: [{:versions, [:"tlsv1.2"]}]],
        # Prefix upload error messages with this
        upload_error_prefix: "SyphtUpload failed:",
        # URL of result end point
        result_url: "https://api.sypht.com/result/final",
        # Retry result requests on server HTTP status
        result_retry_on: [202, 500],
        # Initial backoff milliseconds
        result_initial_backoff: 200,
        # Continue backing off and retrying results for this many milliseconds
        result_retry_until: 300_000,
        # Hackney HTTP options for results
        result_http_options: [
          timeout: 20_000,
          recv_timeout: 150_000,
          ssl: [{:versions, [:"tlsv1.2"]}]
        ],
        # Prefix result error messages with this
        result_error_prefix: "SyphtResult failed:"
      ]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:jason, "~> 1.1"},
      {:httpoison, "~> 1.4", override: true},
      {:cachex, "~> 3.1"}
    ]
  end
end