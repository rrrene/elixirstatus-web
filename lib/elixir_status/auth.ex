defmodule ElixirStatus.Auth do
  def admin?(conn) do
    false
  end

  def logged_in?(conn) do
    !is_nil current_user(conn)
  end

  def current_user(conn) do
    conn.assigns[:current_user]
  end

  def belongs_to_current_user?(conn, object) do
    object.user_id == current_user(conn).id
  end
end
