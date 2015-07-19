defmodule ElixirStatus.PageController do
  use ElixirStatus.Web, :controller

  def about(conn, _params) do
    render conn, "about.html"
  end

  def index(conn, _params) do
    case Auth.current_user(conn) do
      nil -> render conn, "index.html"
      _   -> redirect(conn, to: "/postings")
    end
  end
end
