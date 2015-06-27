defmodule ElixirStatus.UserControllerTest do
  use ElixirStatus.ConnCase

  alias ElixirStatus.User
  @valid_attrs %{email: "some content", full_name: "some content", provider: "some content", user_name: "some content"}
  @invalid_attrs %{}

  setup do
    conn = conn()
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, user_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing"
  end
end
