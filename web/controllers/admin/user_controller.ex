defmodule ElixirStatus.Admin.UserController do
  use ElixirStatus.Web, :controller

  alias ElixirStatus.User

  @layout {ElixirStatus.LayoutView, "admin.html"}

  def create_from_auth_params(user_auth_params) do
    %User{
      full_name: user_auth_params["name"],
      user_name: user_auth_params["login"],
      email: user_auth_params["email"],
      provider: "github"
    } |> Repo.insert!
  end

  def find_by_user_name(user_name, provider \\ "github") do
    query = from u in User,
            where: u.user_name == ^user_name and u.provider == ^provider,
            select: u
    Repo.one(query)
  end

  def find_by_id(user_id) do
    case user_id do
      nil -> nil
      _ -> Repo.get(User, user_id)
    end
  end

  def index(conn, _params) do
    users = Repo.all(User)
    render(conn, "index.html", layout: @layout, users: users)
  end
end
