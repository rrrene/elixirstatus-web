defmodule ElixirStatus.Router do
  use ElixirStatus.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :assign_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ElixirStatus do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/auth", alias: ElixirStatus do
    pipe_through :browser
    get "/", GitHubAuthController, :sign_in
    get "/sign_out", GitHubAuthController, :sign_out
    get "/callback", GitHubAuthController, :callback
  end

  scope "/users", ElixirStatus do
    pipe_through :browser # Use the default browser stack

    get "/", UserController, :index
  end

  # Fetch the current user from the session and add it to `conn.assigns`. This
  # will allow you to have access to the current user in your views with
  # `@current_user`.
  defp assign_current_user(conn, _) do
    assign(conn, :current_user, get_session(conn, :current_user))
  end

  # Other scopes may use custom stacks.
  # scope "/api", ElixirStatus do
  #   pipe_through :api
  # end
end
