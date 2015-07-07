defmodule ElixirStatus.LinkShortenerTest do
  use ElixirStatus.ModelCase

  alias ElixirStatus.LinkShortener

  test "link shortening" do
    url = "http://elixirstatus.com/"
    uid1 = LinkShortener.to_uid(url)
    uid2 = LinkShortener.to_uid(url)

    assert uid1 == uid2

    url2 = LinkShortener.to_url(uid1)

    assert url == url2
  end
end
