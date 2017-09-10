defmodule ElixirStatus.FeedController do
  use ElixirStatus.Web, :controller

  alias ElixirStatus.Avatar
  alias ElixirStatus.Persistence.Posting

  def avatar(conn, %{"user_name" => user_name, "uid" => posting_uid}) do
    posting = Posting.find_by_uid(posting_uid)

    conn
    |> ElixirStatus.Impressionist.record("rss", "posting", posting.uid)
    |> send_file(200, Avatar.image_path(user_name))
  end

  def rss(conn, params) do
    current_user = Auth.current_user(conn)
    admin? = Auth.admin?(conn)
    postings = Posting.published(params, current_user, admin?)
    render(conn, "rss.xml", postings: postings.entries)
  end
end
