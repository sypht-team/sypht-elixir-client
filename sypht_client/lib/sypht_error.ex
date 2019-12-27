defmodule SyphtError do
  @moduledoc """
  Error message generators for the SyphtClient.
  """

  @doc """
  Returns an error message starting with prefix when status is numeric and a nil 
  or blank reason is provided. Status is assumed to be an HTTP status code.
  """
  def message(prefix, status, reason)
      when is_number(status) and (reason == nil or reason == "") do
    "#{prefix} HTTP #{status}"
  end

  @doc """
  Returns an error message starting with prefix when status is numeric and reason is present.
  Reason may be a Sypht error message. 
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
