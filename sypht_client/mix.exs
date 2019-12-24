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
        auth_url: "https://login.sypht.com/oauth/token",
        # Sypht tokens last for 24 hours - reacquire after 23 hours 30 minutes
        auth_ttl: 84_600_000,
        auth_retry_on: [500],
        auth_initial_backoff: 200,
        auth_retry_until: 30_000,
        auth_http_options: [ssl: [{:versions, [:"tlsv1.2"]}]],
        auth_error_prefix: "SyphtAuth failed:",
        upload_url: "https://api.sypht.com/fileupload",
        upload_field_sets: ["sypht.generic"],
        upload_retry_on: [500],
        upload_initial_backoff: 200,
        upload_retry_until: 300_000,
        upload_http_options: [ssl: [{:versions, [:"tlsv1.2"]}]],
        upload_error_prefix: "SyphtUpload failed:",
        result_url: "https://api.sypht.com/result/final",
        result_retry_on: [202, 500],
        result_initial_backoff: 200,
        result_retry_until: 300_000,
        result_http_options: [
          timeout: 20_000,
          recv_timeout: 150_000,
          ssl: [{:versions, [:"tlsv1.2"]}]
        ],
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
