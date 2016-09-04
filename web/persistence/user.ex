defmodule ElixirStatus.Persistence.User do
  import Ecto.Query, only: [from: 2]

  alias ElixirStatus.Repo
  alias ElixirStatus.User

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

  def find_or_create(user_auth_params) do
    %{"login" => user_name, "avatar_url" => url} = user_auth_params
    try do
      ElixirStatus.Avatar.load! user_name, url
    rescue
      e -> IO.inspect {"error", e}
    end

    case find_by_user_name(user_name) do
      nil -> create_from_auth_params(user_auth_params)
      user -> user
    end
  end

  defp create_from_auth_params(user_auth_params) do
    %User{
      full_name: user_auth_params["name"],
      user_name: user_auth_params["login"],
      email: user_auth_params["email"],
      provider: "github"
    } |> Repo.insert!
  end
end