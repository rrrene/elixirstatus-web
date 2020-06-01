defmodule ElixirStatus.UserTest do
  use ElixirStatus.ModelCase

  alias ElixirStatus.User

  @valid_attrs %{
    email: "some content",
    full_name: "some content",
    provider: "some content",
    user_name: "some content"
  }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
