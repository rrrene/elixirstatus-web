defmodule ElixirStatus.ShortLinkControllerTest do
  use ElixirStatus.ConnCase

  alias ElixirStatus.LinkShortener

  setup do
    conn = build_conn()
    {:ok, conn: conn}
  end

  test "shows chosen resource", %{conn: conn} do
    url = "http://github.com"
    uid = LinkShortener.to_uid(url)
    conn = get conn, "/=#{uid}"
    assert html_response(conn, 302)
  end

  test "fails to show chosen resource", %{conn: conn} do
    conn = get conn, "/=2134"
    assert html_response(conn, 302)
  end
end
