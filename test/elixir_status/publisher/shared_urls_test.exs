defmodule ElixirStatus.Publisher.SharedUrlsTest do
  use ElixirStatus.ModelCase

  alias ElixirStatus.Publisher.SharedUrls

  test "expand_url/1 works" do
    expected = ["http://bit.ly/elixir54", "https://app.rdstation.com.br/mail/bf9d63a4-1a96-4c83-9c25-3f17da671882"]
    assert SharedUrls.expand_url("http://bit.ly/elixir54") == expected
  end

  test "collect_and_expand_urls/1 works" do
    text = """
      http://bit.ly/elixir54
      Find it here: https://elixirstatus.com
      """

    expected =
      [
        "http://bit.ly/elixir54",
        "https://app.rdstation.com.br/mail/bf9d63a4-1a96-4c83-9c25-3f17da671882",
        "https://elixirstatus.com"
      ]

    assert SharedUrls.collect_and_expand_urls(text) == expected
  end
end
