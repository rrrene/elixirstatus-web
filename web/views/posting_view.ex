defmodule ElixirStatus.PostingView do
  use ElixirStatus.Web, :view

  def tweet_text(conn, posting) do
    short_title = posting.title |> ElixirStatus.Publisher.short_title
    "[ANN] #{short_title} #{to_short_url(conn, posting)}"
  end

  defp to_short_url(conn, posting) do
    uid = permalink_posting_path(conn, :show, posting.permalink)
            |> ElixirStatus.URL.from_path
            |> ElixirStatus.LinkShortener.to_uid
    short_link_path(conn, :show, uid) |> ElixirStatus.URL.from_path
  end
end
