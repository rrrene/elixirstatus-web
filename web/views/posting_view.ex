defmodule ElixirStatus.PostingView do
  use ElixirStatus.Web, :view
  import ViewHelper

  def tweet_text(conn, posting) do
    short_title = posting.title |> ElixirStatus.Publisher.short_title
    "[ANN] #{short_title} #{to_short_url(conn, posting)}"
  end

  defp to_short_url(conn, posting) do
    uid = permalink_posting_path(conn, :show, posting.permalink)
            |> to_url
            |> ElixirStatus.LinkShortener.to_uid
    short_link_path(conn, :show, uid) |> to_url
  end

  defp to_url(path), do: "#{base_url}#{path}"
  defp base_url, do: Application.get_env(:elixir_status, :base_url)
end
