defmodule Mix.Tasks.Sypht do
  use Mix.Task

  @shortdoc "Send the file specified by path to Sypht and display the results"
  def run([path]) do
    Application.ensure_all_started(:hackney)
    Application.ensure_all_started(:cachex)
    Cachex.start_link(:token_cache, [])
    SyphtClient.send(path) |> IO.inspect()
  end
end
