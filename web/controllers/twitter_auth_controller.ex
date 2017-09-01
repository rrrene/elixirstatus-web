defmodule ElixirStatus.TwitterAuthController do
  use ElixirStatus.Web, :controller

  alias ElixirStatus.User

  plug ElixirStatus.Plugs.LoggedIn when action in [:confirm_handle, :callback]

  def confirm_handle(conn, _params) do
    token = ExTwitter.request_token()
    {:ok, authenticate_url} = ExTwitter.authenticate_url(token.oauth_token)

    redirect(conn, external: authenticate_url)
  end

  def callback(conn, %{"oauth_token" => token, "oauth_verifier" => verifier}) do
    {:ok, access_token} = ExTwitter.access_token(verifier, token)
    %{:screen_name => screen_name} = access_token
    user = Auth.current_user(conn)
    changeset = User.changeset(user, %{"twitter_handle" => screen_name})
    Repo.update!(changeset)
    redirect(conn, to: "/")
  end
end
