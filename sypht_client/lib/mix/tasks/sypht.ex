defmodule Mix.Tasks.Sypht do
  @moduledoc """
  Invoke SyphtClient.Workflow.send(path) from the command line.
  """
  use Mix.Task

  @doc """
  Send the file at path to Sypht and display the decoded response.

  ## Examples

  `mix sypht my-file.pdf`

  `{:ok, %{
     "fileId" => "5fd47912-70e9-40fb-9af7-afae1969d9a3",
     "results" => %{
       "fields" => [
         %{
           "boundingBox" => nil,
           "confidence" => 1,
           "name" => "generic.structure",
           "value" => %{ ...
       ]
       ...
     }
   }}`
  """
  def run([path]) do
    Application.ensure_all_started(:hackney)
    Application.ensure_all_started(:cachex)
    Cachex.start_link(:token_cache, [])
    SyphtClient.Workflow.send(path) |> IO.inspect()
  end
end
