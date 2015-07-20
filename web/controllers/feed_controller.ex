defmodule ElixirStatus.FeedController do
  use ElixirStatus.Web, :controller

  alias ElixirStatus.PostingController

  def rss(conn, _params) do
    postings = PostingController.get_all
    render(conn, "index.xml", postings: postings.entries)
  end
end
