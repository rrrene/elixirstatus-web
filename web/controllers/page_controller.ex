defmodule ElixirStatus.PageController do
  use ElixirStatus.Web, :controller

  alias ElixirStatus.Avatar

  def about(conn, _params) do
    render conn, "about.html"
  end

  def avatar(conn, %{"user_name" => user_name}) do
    conn
    |> send_file(200, Avatar.image_path(user_name))
  end

  def index(conn, _params) do
    case Auth.current_user(conn) do
      nil -> render conn, "index.html"
      _   -> redirect(conn, to: "/postings")
    end
  end

  def open_source(conn, _params) do
    render conn, "open_source.html"
  end
end
