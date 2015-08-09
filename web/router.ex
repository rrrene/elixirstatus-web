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
    plug :fetch_session
    plug :assign_current_user
  end

  scope "/", ElixirStatus do
    pipe_through :browser # Use the default browser stack

    get "/", PostingController, :index
    get "/rss", FeedController, :rss
    get "/about", PageController, :about

    get "/rss/avatar/:user_name", FeedController, :avatar
    get "/avatar/github/:user_name", PageController, :avatar

    get "/postings/preview", PostingController, :preview, as: :preview_posting
    post "/postings/unpublish/:id", PostingController, :unpublish
    resources "/postings", PostingController
    get "/p/:permalink", PostingController, :show, as: :permalink_posting
    get "/p/edit/:permalink", PostingController, :edit

    get "/=:uid", ShortLinkController, :show
  end

  scope "/auth", alias: ElixirStatus do
    pipe_through :browser

    get "/", GitHubAuthController, :sign_in
    get "/sign_out", GitHubAuthController, :sign_out
    get "/callback", GitHubAuthController, :callback
  end

  scope "/admin", alias: ElixirStatus.Admin do
    pipe_through :browser

    get "/", OverviewController, :index
    get "/users", UserController, :index
    get "/postings", PostingController, :index
  end

  # Other scopes may use custom stacks.
  scope "/impression", ElixirStatus do
    pipe_through :api

    post "/", ImpressionController, :create, as: :impression
  end

  # Other scopes may use custom stacks.
  scope "/api", ElixirStatus do
    pipe_through :api

    post "/external", ImpressionController, :external, as: :external
    post "/postings", ImpressionController, :postings, as: :postings
  end

  # Fetch the current user from the session and add it to `conn.assigns`. This
  # will allow you to have access to the current user in your views with
  # `@current_user`.
  defp assign_current_user(conn, _) do
    user_id = get_session(conn, :current_user_id)
    assign(conn, :current_user, ElixirStatus.Admin.UserController.find_by_id(user_id))
  end

  # Other scopes may use custom stacks.
  # scope "/api", ElixirStatus do
  #   pipe_through :api
  # end
end
