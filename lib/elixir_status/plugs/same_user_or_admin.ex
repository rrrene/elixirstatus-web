defmodule ElixirStatus.Plugs.SameUserOrAdmin do
  @moduledoc """
  """
  use ElixirStatus.Web, :controller
  alias ElixirStatus.Auth

  def init(default), do: default

  def call(conn, object_assign_key) do
    object = conn.assigns[object_assign_key]

    if Auth.belongs_to_current_user?(conn, object) || Auth.admin?(conn) do
      conn
    else
      redirect(conn, to: "/") |> halt
    end
  end
end
