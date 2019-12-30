defmodule SyphtClient.Error do
  @moduledoc false

  def message(prefix, status, reason)
      when is_number(status) and (reason == nil or reason == "") do
    "#{prefix} HTTP #{status}"
  end

  def message(prefix, status, reason) when is_number(status) do
    case Jason.decode(reason) do
      {:ok, %{"message" => message}} ->
        "#{prefix} HTTP #{status} -> #{message}"

      _ ->
        "#{prefix} HTTP #{status} -> #{reason}"
    end
  end

  def message(prefix, status) when is_number(status) do
    "#{prefix} HTTP #{status}"
  end

  def message(prefix, reason) when is_atom(reason) do
    "#{prefix} #{Atom.to_string(reason)}"
  end

  def message(prefix, reason) do
    "#{prefix} #{reason}"
  end
end
