defmodule ElixirStatus.PublisherTest do
  use ElixirStatus.ModelCase
  use Timex

  alias ElixirStatus.Publisher
  alias ElixirStatus.Posting

  @valid_attrs %{title: "some content", text: "some content", permalink: "some-content", public: true, published_at: Date.now, scheduled_at: nil, uid: "some content", user_id: 42}
  @invalid_attrs %{}

  test "after_create works without twitter_handle" do
    changeset = Posting.changeset(%Posting{}, @valid_attrs)
    assert changeset.valid?

    Repo.insert!(changeset)
    |> Publisher.after_create(nil)
  end

  test "after_create works with twitter_handle" do
    changeset = Posting.changeset(%Posting{}, @valid_attrs)
    assert changeset.valid?

    Repo.insert!(changeset)
    |> Publisher.after_create("rrrene")
  end

  test "short title for long titles" do
    input = "Remember this function works with unicode codepoints and consider the slices to represent codepoints offsets. If you want to split on raw bytes, check Kernel.binary_part/3 instead."
    expected = "Remembe..."
    result = Publisher.short_title(input, 10)
    assert 10 == String.length(result)
    assert expected == result
  end

  test "short title for short titles" do
    input = "Remember"
    expected = "Remember"
    result = Publisher.short_title(input, 10)
    assert String.length(input) < 10
    assert expected == result
  end

  test "permalink" do
    expected = "aB87-i-really-like-this-title"
    result = Publisher.permalink("aB87", "I really like this TiTlE")
    assert expected == result
  end

  test "tweet_text with twitter handle" do
    posting = %Posting{title: "Title goes here"}
    expected_start = "Title goes here by @rrrene"
    assert Publisher.tweet_text(posting, "rrrene") |> String.starts_with?(expected_start)
  end
end
