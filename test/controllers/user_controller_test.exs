defmodule ElixirStatus.UserControllerTest do
  use ElixirStatus.ConnCase

  setup do
    conn = build_conn()
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get(conn, user_path(conn, :index))
    assert html_response(conn, 200) =~ "Listing"
  end
end
