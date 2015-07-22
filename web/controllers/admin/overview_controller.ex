defmodule ElixirStatus.Admin.OverviewController do
  use ElixirStatus.Web, :controller

  plug ElixirStatus.Plugs.Admin

  def index(conn, _params) do
    render conn, "index.html"
  end
end
