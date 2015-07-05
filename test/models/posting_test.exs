defmodule ElixirStatus.PostingTest do
  use ElixirStatus.ModelCase

  alias ElixirStatus.Posting

  @valid_attrs %{permalink: "some content", public: true, published_at: %{day: 17, hour: 14, min: 0, month: 4, year: 2010}, scheduled_at: %{day: 17, hour: 14, min: 0, month: 4, year: 2010}, text: "some content", title: "some content", uid: "some content", user_id: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Posting.changeset(%Posting{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Posting.changeset(%Posting{}, @invalid_attrs)
    refute changeset.valid?
  end
end
