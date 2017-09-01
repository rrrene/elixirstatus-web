defmodule ElixirStatus.UserController do
  use ElixirStatus.Web, :controller

  require Logger

  alias ElixirStatus.User

  @current_user_assign_key :user

  plug ElixirStatus.Plugs.LoggedIn when action in [:edit, :update]

  def edit(conn, _) do
    user = Auth.current_user(conn)
    changeset = User.changeset(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, _) do
    user = Auth.current_user(conn)
    changeset = User.changeset(user, %{twitter_handle: nil})

    if changeset.valid? do
      Repo.update!(changeset)

      conn
      |> put_flash(:info, "Disconnected Twitter handle.")
      |> redirect(to: "/")
    else
      Logger.error "POST update_profile: #{inspect(changeset.errors)}"
      render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

end
