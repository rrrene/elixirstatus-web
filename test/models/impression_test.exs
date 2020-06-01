defmodule ElixirStatus.ImpressionTest do
  use ElixirStatus.ModelCase

  alias ElixirStatus.Impression

  @valid_attrs %{
    path: "/",
    accept_language: "some content",
    context: "frontpage",
    current_user_id: 1234,
    remote_ip: "127.0.0.1",
    session_hash: "some content",
    subject_type: "posting",
    subject_uid: "a2d1",
    user_agent: "some content"
  }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Impression.changeset(%Impression{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Impression.changeset(%Impression{}, @invalid_attrs)
    refute changeset.valid?
  end
end
