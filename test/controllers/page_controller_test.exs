defmodule ElixirStatus.PageControllerTest do
  use ElixirStatus.ConnCase

  test "GET /" do
    conn = get conn(), "/"
    assert html_response(conn, 200) =~ "elixirstatus"
  end
end
