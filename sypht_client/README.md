# SyphtClient

An Elixir client for the Sypht API <https://sypht.com>

The method SyphtClient.Workflow.send\1 demonstrates the API:

```elixir
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
```

The `sypht` mix task included in this repo lets you call this from the command line. The workflow can take a little while.

The client is designed to run in a consumer or worker process started by something like [ConsumerSupervisor](https://hexdocs.pm/gen_stage/ConsumerSupervisor.html), [Flow](https://hexdocs.pm/flow/Flow.html) or [Broadway](https://hexdocs.pm/broadway/Broadway.html). Sypht API calls will retry failed requests based on configuration settings. See mix.exs for details.

If you want finer-grained control, invoke the methods in the SyphtAuth, SyphtUpload and SyphtResult modules directly.

All Sypht client APIs depend on the environment variable SYPHT_API_KEY for authentication. This variable must be provided in the format CLIENT_ID:CLIENT_SECRET.

You will as a minimum want to override the default upload_field_sets configuration value. See mix.exs and config.exs for details.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `sypht_client` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:sypht_client, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/sypht_client](https://hexdocs.pm/sypht_client).
