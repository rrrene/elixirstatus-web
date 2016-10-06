defmodule ElixirStatus.FeedController do
  use ElixirStatus.Web, :controller

  alias ElixirStatus.Persistence.Posting

  def avatar(conn, %{"user_name" => user_name, "uid" => posting_uid}) do
    posting = Posting.find_by_uid(posting_uid)

    conn
    |> ElixirStatus.Impressionist.record("rss", "posting", posting.uid)
    |> send_file(200, "priv/static/images/github/#{user_name}.jpg")
  end

  def rss(conn, _params) do
    postings = Posting.published
    render(conn, "rss.xml", postings: postings.entries)
  end
end
