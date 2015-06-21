defmodule ElixirStatus.PageController do
  use ElixirStatus.Web, :controller

  plug :action

  def index(conn, _params) do
    render conn, "index.html"
  end
end
