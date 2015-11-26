defmodule ElixirStatus.Admin.PostingView do
  use ElixirStatus.Web, :view

  def to_short_uid(permalink) do
    "/p/#{permalink}"
      |> ElixirStatus.URL.from_path
      |> ElixirStatus.LinkShortener.to_uid
  end

  def render("recent.json", %{postings: postings, conn: conn}) do
    data = Enum.map(postings, &to_json(&1, conn))
    %{
      postings: data,
      # TODO: first_time_authors
    }
  end

  def to_json(posting, conn) do
    %{
      id: posting.id,
      published_at: posting.published_at,
      title: posting.title,
      permalink: permalink_posting_path(conn, :show, posting.permalink),
      link_clicks: ElixirStatus.Impressionist.count("postings:#{posting.uid}", "short_link")
    }
  end
end
