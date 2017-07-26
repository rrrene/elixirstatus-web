defmodule ElixirStatus.TwitterAuthController do
  use ElixirStatus.Web, :controller

  require Logger

  alias ElixirStatus.User


  plug ElixirStatus.Plugs.LoggedIn when action in [:sign_in, :callback]

  @doc """
  This action is reached via `/auth` and redirects to the OAuth2 provider
  based on the chosen strategy.
  """
  def sign_in(conn, _params) do
    handle_sign_in_for(Mix.env, conn)
  end

  defp handle_sign_in_for(_, conn) do
    redirect conn, external: TwitterAuth.authorize_url!
  end


  def callback(conn, %{"oauth_token" => token, "oauth_verifier" => verifier}) do

    twitter_handle = TwitterAuth.get_handle(token,verifier)
    
    user = Auth.current_user(conn)
  
    changeset = User.changeset(user,  %{"twitter_handle" => twitter_handle})

    if changeset.valid? do
      Repo.update!(changeset)

      conn
      |> put_flash(:info, "User updated successfully.")
      |> redirect(to: "/")
    else
      Logger.error "POST update_profile: #{inspect(changeset.errors)}"
      
    end
    
  end

end
