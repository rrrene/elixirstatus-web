defmodule ElixirStatus.ShortLinkTest do
  use ElixirStatus.ModelCase

  alias ElixirStatus.ShortLink

  @valid_attrs %{uid: "some content", url: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = ShortLink.changeset(%ShortLink{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = ShortLink.changeset(%ShortLink{}, @invalid_attrs)
    refute changeset.valid?
  end
end
