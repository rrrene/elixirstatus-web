defmodule ElixirStatus.ImpressionController do
  use ElixirStatus.Web, :controller

  alias ElixirStatus.Impressionist
  alias ElixirStatus.LinkShortener

  def create(conn, impression_params) do
    conn
      |> Impressionist.record(impression_params)
      |> json(%{"ok" => true})
  end

  def external(conn, %{"uid" => posting_uid, "url" => url}) do
    link_uid = LinkShortener.to_uid(url)
    conn
      |> Impressionist.record("postings:#{posting_uid}", "short_links", link_uid)
      |> json(%{"ok" => true})
  end

  def postings(conn, %{"context" => context, "uids" => posting_uids}) do
    posting_uids
      |> String.split(",")
      |> Enum.each(fn uid ->
          Impressionist.record(conn, context, "posting", uid)
        end)

    json(conn, %{"ok" => true})
  end
end
