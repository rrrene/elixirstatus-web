defmodule ElixirStatus.GitHubAuthController do
  use ElixirStatus.Web, :controller

  plug :action

  @doc """
  This action is reached via `/auth` and redirects to the OAuth2 provider
  based on the chosen strategy.
  """
  def sign_in(conn, _params) do
    redirect conn, external: GitHubAuth.authorize_url!
  end

  @doc """
  This action is reached via `/auth/sign_out` and redirects to the OAuth2 provider
  based on the chosen strategy.
  """
  def sign_out(conn, _params) do
    conn
    |> put_session(:current_user, nil)
    |> put_session(:access_token, nil)
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
    user_auth_params = OAuth2.AccessToken.get!(token, "/user")

    find_or_create_user(user_auth_params)

    # Store the user in the session under `:current_user` and redirect to /.
    # In most cases, we'd probably just store the user's ID that can be used
    # to fetch from the database. In this case, since this example app has no
    # database, I'm just storing the user map.
    #
    # If you need to make additional resource requests, you may want to store
    # the access token as well.
    conn
    |> put_session(:current_user, user_auth_params)
    |> put_session(:access_token, token.access_token)
    |> redirect(to: "/")
  end

  def find_or_create_user(user_auth_params) do
    user = ElixirStatus.UserController.find_by_user_name(user_auth_params["login"])
    if !user do
      user = ElixirStatus.UserController.create_from_auth_params(user_auth_params)
    end
    user
  end
end

