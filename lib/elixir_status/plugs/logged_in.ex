defmodule ElixirStatus.Plugs.LoggedIn do
  @moduledoc """
  """
  use ElixirStatus.Web, :controller
  alias ElixirStatus.Auth

  def init(default), do: default

  def call(conn, _default) do
    case Auth.current_user(conn) do
      nil -> redirect(conn, to: "/") |> halt
      _   -> conn
    end
  end
end
