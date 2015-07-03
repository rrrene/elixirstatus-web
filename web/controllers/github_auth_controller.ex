defmodule ElixirStatus.GitHubAuthController do
  use ElixirStatus.Web, :controller
  alias ElixirStatus.UserController

  @doc """
  This action is reached via `/auth` and redirects to the OAuth2 provider
  based on the chosen strategy.
  """
  def sign_in(conn, _params) do
    handle_sign_in_for(Mix.env, conn)
  end

  defp handle_sign_in_for(:test, conn) do
    sign_in_via_auth conn, %{"name" => "René Föhring", "login" => "rrrene", "email" => "rf@bamaru.de", "avatar_url" => "http://elixirstatus.com/images/avatar_rrrene.jpg"}
  end

  defp handle_sign_in_for(_, conn) do
    redirect conn, external: GitHubAuth.authorize_url!
  end

  @doc """
  This action is reached via `/auth/sign_out` and redirects to the OAuth2 provider
  based on the chosen strategy.
  """
  def sign_out(conn, _params) do
    conn
    |> put_session(:current_user_id, nil)
    |> redirect(to: "/")
  end

  @doc """
  This action is reached via `/auth/callback` is the the callback URL that
  the OAuth2 provider will redirect the user back to with a `code` that will
  be used to request an access token. The access token will then be used to
  access protected resources on behalf of the user.
  """
  def callback(conn, %{"code" => code}) do
    # Exchange an auth code for an access token
    token = GitHubAuth.get_token!(code: code)

    # Request the user's data with the access token
    sign_in_via_auth conn, OAuth2.AccessToken.get!(token, "/user")
  end

  defp sign_in_via_auth(conn, user_auth_params) do
    current_user = find_or_create_user(user_auth_params)

    conn
    |> put_session(:current_user_id, current_user.id)
    |> redirect(to: "/")
  end

  def find_or_create_user(user_auth_params) do
    %{"login" => user_name, "avatar_url" => url} = user_auth_params
    try do
      ElixirStatus.Avatar.load! user_name, url
    rescue
      e -> IO.inspect {"error", e}
    end

    case UserController.find_by_user_name(user_name) do
      nil -> UserController.create_from_auth_params(user_auth_params)
      user -> user
    end
  end
end
