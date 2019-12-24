defmodule SyphtError do
  @moduledoc """
  Error message generators for the SyphtClient.
  """

  @doc """
  Returns an error message starting with prefix when status is numeric and a Sypht error message is present. 
  Status is assumed to be an HTTP status code.
  """
  def message(prefix, status, reason) when is_number(status) do
    case Jason.decode(reason) do
      {:ok, %{"message" => message}} ->
        "#{prefix} HTTP #{status} -> #{message}"

      _ ->
        "#{prefix} HTTP #{status} -> #{reason}"
    end
  end

  @doc """
  Returns an error message starting with prefix when status is numeric. 
  Status is assumed to be an HTTP status code.
  """
  def message(prefix, status) when is_number(status) do
    "#{prefix} HTTP #{status}"
  end

  @doc """
  Returns an error message starting with prefix when reason is an atom. 
  """
  def message(prefix, reason) when is_atom(reason) do
    "#{prefix} #{Atom.to_string(reason)}"
  end

  @doc """
  Returns an error message starting with prefix when reason matches no guards.
  """
  def message(prefix, reason) do
    "#{prefix} #{reason}"
  end
end
