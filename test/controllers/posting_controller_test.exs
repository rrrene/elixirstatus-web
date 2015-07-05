defmodule ElixirStatus.PostingControllerTest do
  use ElixirStatus.ConnCase
  use ElixirStatus.ConnLoginHelper

  alias ElixirStatus.Posting
  @valid_attrs %{text: "some content", title: "some content"}
  @invalid_attrs %{permalink: "haxxor-perma-link", public: true, published_at: %{day: 17, hour: 14, min: 0, month: 4, year: 2010}, scheduled_at: %{day: 17, hour: 14, min: 0, month: 4, year: 2010}, uid: "some content", user_id: 42}

  setup do
    conn = conn()
    {:ok, conn: conn}
  end

  defp valid_posting(user_id: user_id) do
    %Posting{valid_posting | user_id: user_id}
  end

  defp valid_posting() do
    %Posting{user_id: 1234, text: "gibberish", title: "some more gibberish",
            uid: "abcd", permalink: "abcd-some-more-gibberish",
            public: true, published_at: Ecto.DateTime.utc}
  end

  #
  # CREATE
  #

  @tag posting_create: true
  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = logged_in_conn()
            |> post posting_path(conn, :create), posting: @valid_attrs

    assert Repo.get_by(Posting, @valid_attrs)
    assert redirected_to(conn) == posting_path(conn, :index)
  end

  @tag posting_create: true
  test "when NOT logged in -> does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = logged_out_conn()
            |> post posting_path(conn, :create), posting: @valid_attrs

    refute Repo.get_by(Posting, @valid_attrs)
    assert_login_required(conn)
  end

  @tag posting_create: true
  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = logged_in_conn()
            |> post posting_path(conn, :create), posting: @invalid_attrs

    assert html_response(conn, 200) =~ "New posting"
  end

  #
  # EDIT
  #

  @tag posting_edit: true
  test "when NOT logged in -> redirects to root", _ do
    conn = logged_out_conn()
    posting = Repo.insert! valid_posting
    conn = get conn, posting_path(conn, :edit, posting)
    assert_login_required(conn)
  end

  @tag posting_edit: true
  test "does not render form for editing chosen resource if not same user", _ do
    conn = logged_in_conn()
    posting = Repo.insert! valid_posting(user_id: 1234)
    conn = get conn, posting_path(conn, :edit, posting)
    assert_same_user_required(conn)
  end

  @tag posting_edit: true
  test "renders form for editing chosen resource if same user", _ do
    conn = logged_in_conn()
    posting = Repo.insert! valid_posting(user_id: current_user(conn).id)
    conn = get conn, posting_path(conn, :edit, posting)
    assert html_response(conn, 200) =~ "Edit posting"
  end

  #
  # UPDATE
  #

  @tag posting_update: true
  test "does not update chosen resource if not logged in", %{conn: conn} do
    posting = Repo.insert! valid_posting
    conn = logged_out_conn()
        |> put posting_path(conn, :update, posting), posting: @valid_attrs

    assert_login_required(conn)
  end

  @tag posting_update: true
  test "does not update chosen resource if not same user", %{conn: conn} do
    posting = Repo.insert! valid_posting(user_id: 1234)
    conn = logged_in_conn()
        |> put posting_path(conn, :update, posting), posting: @valid_attrs

    assert_same_user_required(conn)
  end

  @tag posting_update: true
  test "does not update permalink and other invalid attributes", _ do
    invalid_attr = %{permalink: "i-hacked-the-permalink"}
    invalid_params = %{"permalink" => "i-hacked-the-permalink"}
    conn = logged_in_conn()
    posting = Repo.insert! valid_posting(user_id: current_user(conn).id)
    conn = conn
            |> put posting_path(conn, :update, posting), posting: invalid_params

    refute Repo.get_by(Posting, invalid_attr)
    assert redirected_to(conn) == posting_path(conn, :index)
  end

  @tag posting_update: true
  test "does not update if title is empty", _ do
    invalid_attr = %{title: "   "}
    invalid_params = %{"title" => "   "}
    conn = logged_in_conn()
    posting = Repo.insert! valid_posting(user_id: current_user(conn).id)
    conn = conn
            |> put posting_path(conn, :update, posting), posting: invalid_params

    refute Repo.get_by(Posting, invalid_attr)
    assert redirected_to(conn) == posting_path(conn, :index)
  end

  @tag posting_update: true
  test "does not update if text is empty", _ do
    invalid_attr = %{text: "   "}
    invalid_params = %{"text" => "   "}
    conn = logged_in_conn()
    posting = Repo.insert! valid_posting(user_id: current_user(conn).id)
    conn = conn
            |> put posting_path(conn, :update, posting), posting: invalid_params

    refute Repo.get_by(Posting, invalid_attr)
    assert redirected_to(conn) == posting_path(conn, :index)
  end

  @tag posting_update: true
  test "updates chosen resource and redirects when data is valid", _ do
    conn = logged_in_conn()
    posting = Repo.insert! valid_posting(user_id: current_user(conn).id)
    conn = conn
            |> put posting_path(conn, :update, posting), posting: @valid_attrs

    assert Repo.get_by(Posting, @valid_attrs)
    assert redirected_to(conn) == posting_path(conn, :index)
  end

  #
  # INDEX
  #

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, posting_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing postings"
  end

  #
  # NEW
  #

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, posting_path(conn, :new)
    assert html_response(conn, 200) =~ "New posting"
  end

  #
  # SHOW
  #

  test "shows posting", _ do
    posting = Repo.insert! valid_posting
    conn = get conn, posting_path(conn, :show, posting)
    assert html_response(conn, 200) =~ posting.title
  end

  test "shows posting via permalink", _ do
    posting = Repo.insert! valid_posting
    conn = get conn, permalink_posting_path(conn, :show, posting.permalink)
    assert html_response(conn, 200) =~ posting.title
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    conn = get conn, posting_path(conn, :show, -1)
    assert html_response(conn, 404)
  end

  #
  # DELETE
  #

  @tag posting_delete: true
  test "does not delete chosen resource if not logged in", _ do
    posting = Repo.insert! valid_posting(user_id: 1234)
    conn = logged_out_conn()
        |> delete posting_path(conn, :delete, posting)

    assert_login_required(conn)
  end

  @tag posting_delete: true
  test "does not delete chosen resource if not same user", _ do
    posting = Repo.insert! valid_posting(user_id: 1234)
    conn = logged_in_conn()
        |> delete posting_path(conn, :delete, posting)

    assert_same_user_required(conn)
  end

  @tag posting_delete: true
  test "deletes chosen resource", _ do
    conn = logged_in_conn()
    posting = Repo.insert! valid_posting(user_id: current_user(conn).id)
    conn = conn
            |> delete posting_path(conn, :delete, posting)

    assert redirected_to(conn) == posting_path(conn, :index)
    refute Repo.get(Posting, posting.id)
  end
end
