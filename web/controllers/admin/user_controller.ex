defmodule ElixirStatus.Admin.UserController do
  use ElixirStatus.Web, :controller

  @layout {ElixirStatus.LayoutView, "admin.html"}

  def index(conn, _params) do
    users = Repo.all(User)
    render(conn, "index.html", layout: @layout, users: users)
  end
end
