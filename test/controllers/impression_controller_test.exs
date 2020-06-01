defmodule ElixirStatus.ImpressionControllerTest do
  use ElixirStatus.ConnCase

  alias ElixirStatus.Impression
  @valid_attrs %{context: "frontpage", subject_type: "posting", subject_uid: "acds"}
  @invalid_attrs %{context: ""}

  setup do
    conn = build_conn()
    {:ok, conn: conn}
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    post_attrs = %{"context" => "frontpage", "subject_type" => "posting", "subject_uid" => "acds"}
    conn = post(conn, impression_path(conn, :create), post_attrs)
    assert json_response(conn, 200)["ok"]
    :timer.sleep(300)
    assert Repo.get_by(Impression, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post(conn, impression_path(conn, :create), @invalid_attrs)
    refute Repo.get_by(Impression, @invalid_attrs)
    :timer.sleep(300)
    assert json_response(conn, 200)["ok"]
  end
end
