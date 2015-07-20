defmodule ElixirStatus.PageControllerTest do
  use ElixirStatus.ConnCase
  use ElixirStatus.ConnLoginHelper

  test "GET /" do
    conn = get conn(), "/"
    assert html_response(conn, 200) =~ "elixirstatus"
  end

  test "GET / (logged in)" do
    conn = logged_in_conn()
            |> get "/"
    assert html_response(conn, 302)
  end

  @tag logged_in: true
  test "GET /about (logged in)" do
    conn = logged_in_conn()
            |> get "/about"
    assert logged_in?(conn)
  end
end
