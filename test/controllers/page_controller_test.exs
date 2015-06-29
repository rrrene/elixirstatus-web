defmodule ElixirStatus.PageControllerTest do
  use ElixirStatus.ConnCase

  test "GET /" do
    conn = get conn(), "/"
    assert html_response(conn, 200) =~ "elixirstatus"
  end

  @tag logged_in: true
  test "GET / (logged in)" do
    conn = get conn(), "/auth"
    assert html_response(conn, 302)
  end
end
