defmodule ElixirStatus.TwitterAuthController do
  use ElixirStatus.Web, :controller

  alias ElixirStatus.User

  plug ElixirStatus.Plugs.LoggedIn

  @twitter_config Application.get_env(:elixir_status, :twitter_oauth_for_handle_verification)

  def confirm_handle(conn, _params) do
    configure_extwitter_for_process()

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

    redirect(conn, to: edit_user_path(conn, :edit))
  end

  defp configure_extwitter_for_process do
    ExTwitter.configure(:process, @twitter_config)
  end
end
