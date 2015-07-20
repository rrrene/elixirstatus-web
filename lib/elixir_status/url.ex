defmodule ElixirStatus.URL do
  @moduledoc """
    Converts URLs.
  """

  @base_url Application.get_env(:elixir_status, :base_url)

  @doc "Returns an absolute URL for a given +path+."
  def from_path(path), do: "#{@base_url}#{path}"
end
