defmodule SyphtClient.MixProject do
  use Mix.Project

  def project do
    [
      app: :sypht_client,
      name: "SyphtClient",
      version: "0.1.1",
      elixir: "~> 1.9",
      description: description(),
      package: package(),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      source_url: "https://github.com/sypht-team/sypht-elixir-client/sypht_client",
      docs: [
        source_url_pattern:
          "https://github.com/sypht-team/sypht-elixir-client/blob/master/sypht_client/%{path}#L%{line}"
      ]
    ]
  end

  defp description() do
    "A client for the Sypht OCR API (https://www.sypht.com/). Workflow encapsulated in SyphtClient.send\\1."
  end

  defp package() do
    [
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/sypht-team/sypht-elixir-client"}
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {SyphtClient.App, []},
      env: [
        # URL of token acquisition end point
        auth_url: "https://login.sypht.com/oauth/token",
        # Token TTL. Sypht tokens last for 24 hours - reacquire after 23 hours 30 minutes
        auth_ttl: 84_600_000,
        # Retry token acquisition on server HTTP status
        auth_retry_on: [500],
        # Initial backoff milliseconds
        auth_initial_backoff: 200,
        # Continue backing off and retrying until this many milliseconds have elapsed
        auth_retry_until: 30_000,
        # Hackney HTTP options for authentication
        auth_http_options: [ssl: [{:versions, [:"tlsv1.2"]}]],
        # Prefix authentication error messages with this
        auth_error_prefix: "SyphtAuth failed:",
        # URL of file upload end point
        upload_url: "https://api.sypht.com/fileupload",
        # Sypht field set(s) to invoke (see https://docs.sypht.com/#section/Introduction)
        upload_field_sets: ["sypht.generic"],
        # Retry uploads on server HTTP status
        upload_retry_on: [500],
        # Initial backoff milliseconds
        upload_initial_backoff: 200,
        # Continue backing off and retrying until this many milliseconds have elapsed
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
        # Continue backing off and retrying until this many milliseconds have elapsed
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
      {:httpoison, "~> 1.4"},
      {:cachex, "~> 3.1"},
      {:ex_doc, "~> 0.21", only: :dev, runtime: false}
    ]
  end
end
