defmodule ElixirStatus.Plugs.Admin do
  @moduledoc """
  """
  use ElixirStatus.Web, :controller
  alias ElixirStatus.Auth

  def init(default), do: default

  def call(conn, _default) do
    if Auth.admin?(conn) do
      conn
    else
      conn |> redirect(to: "/") |> halt
    end
  end
end
