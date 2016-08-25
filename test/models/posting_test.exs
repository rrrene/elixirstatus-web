defmodule ElixirStatus.PostingTest do
  use ElixirStatus.ModelCase

  alias ElixirStatus.Posting

  @valid_attrs %{title: "some content", text: "some content", permalink: "some content", public: true, published_at: Ecto.DateTime.utc, scheduled_at: nil, uid: "some content", user_id: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Posting.changeset(%Posting{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Posting.changeset(%Posting{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "changeset with invalid attribute: title" do
    attrs = %{@valid_attrs | title: ""}
    changeset = Posting.changeset(%Posting{}, attrs)
    refute changeset.valid?
  end

  test "changeset with invalid attribute: text" do
    attrs = %{@valid_attrs | text: ""}
    changeset = Posting.changeset(%Posting{}, attrs)
    refute changeset.valid?
  end
end
