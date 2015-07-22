defmodule ElixirStatus.FeedController do
  use ElixirStatus.Web, :controller

  alias ElixirStatus.PostingController

  def avatar(conn, %{"user_name" => user_name, "uid" => posting_uid}) do
    posting = PostingController.get_by_uid(posting_uid)

    conn
      |> ElixirStatus.Impressionist.record("rss", "postings", posting.uid)
      |> send_file(200, "priv/static/images/github/#{user_name}.jpg")
  end

  def rss(conn, _params) do
    postings = PostingController.get_all
    render(conn, "rss.xml", postings: postings.entries)
  end
end
