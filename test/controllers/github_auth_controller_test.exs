defmodule ElixirStatus.GitHubAuthControllerTest do
  use ElixirStatus.ConnCase

  @tag logged_in: true
  test "GET /auth (logged in)" do
    conn = get conn(), "/auth"
    assert html_response(conn, 302)

    conn = get conn, "/auth/sign_out"
    assert html_response(conn, 302)
  end
end
