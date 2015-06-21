defmodule ElixirStatus.UserController do
  use ElixirStatus.Web, :controller

  alias ElixirStatus.User

  plug :action

  def create_from_auth_params(user_auth_params) do
    user_params = %User{
      full_name: user_auth_params["name"],
      user_name: user_auth_params["login"],
      email: user_auth_params["email"],
      provider: "git_hub",
    }
    Repo.insert(user_params)
  end

  def find_by_email(email, provider \\ "git_hub") do
    query = from u in User,
            where: u.email == ^email and u.provider == ^provider,
            select: u
    Repo.one(query)
  end

  def index(conn, _params) do
    users = Repo.all(User)
    render(conn, "index.html", users: users)
  end
end
