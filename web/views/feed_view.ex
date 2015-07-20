defmodule ElixirStatus.FeedView do
  use ElixirStatus.Web, :view
  import ViewHelper

  def to_short_url(conn, posting) do
    permalink_posting_path(conn, :show, posting.permalink)
          |> to_url
  end

  defp to_url(path), do: "#{base_url}#{path}"
  defp base_url, do: Application.get_env(:elixir_status, :base_url)
end
