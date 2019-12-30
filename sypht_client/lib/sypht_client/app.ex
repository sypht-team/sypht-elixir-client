defmodule SyphtClient.App do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      %{
        id: Cachex,
        start: {Cachex, :start_link, [:token_cache, []]}
      }
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
