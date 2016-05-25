defmodule ElixirStatus.UserController do
  use ElixirStatus.Web, :controller
  use Timex

  alias ElixirStatus.User

  @current_user_assign_key :user

  plug ElixirStatus.Plugs.LoggedIn when action in [:edit, :update]

  plug :scrub_params, "user" when action in [:create, :update]

  def edit(conn, _) do
    user = Auth.current_user(conn)
    changeset = User.changeset(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"user" => user_params}) do
    user = Auth.current_user(conn)
    user_params = user_params |> extract_valid_params
    changeset = User.changeset(user, user_params)

    if changeset.valid? do
      Repo.update!(changeset)

      conn
      |> put_flash(:info, "User updated successfully.")
      |> redirect(to: "/")
    else
      Logger.error "POST update_profile: #{inspect(changeset.errors)}"
      render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  defp extract_valid_params(%{"twitter_handle" => twitter_handle}) when is_binary(twitter_handle) do
    %{"twitter_handle" => twitter_handle |> String.replace("@", "")}
  end
  defp extract_valid_params(%{"twitter_handle" => nil}) do
    %{"twitter_handle" => nil}
  end
  defp extract_valid_params(_) do
    %{}
  end

end
