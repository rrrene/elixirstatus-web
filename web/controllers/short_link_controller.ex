defmodule ElixirStatus.ShortLinkController do
  use ElixirStatus.Web, :controller

  alias ElixirStatus.LinkShortener

  @homepage_url "http://elixirstatus.com"

  def show(conn, %{"uid" => uid}) do
    conn
      |> ElixirStatus.Impressionist.record("detail", "short_link", uid)
      |> redirect(external: LinkShortener.to_url(uid) || @homepage_url)
  end
end
