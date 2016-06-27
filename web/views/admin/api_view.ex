defmodule ElixirStatus.Admin.ApiView do
  use ElixirStatus.Web, :view

  alias ElixirStatus.Impressionist

  def render("recent.json", %{postings: postings, stats_clicks: stats_clicks, stats_views: stats_views, conn: conn}) do
    data = Enum.map(postings, &to_json(&1, conn, stats_clicks, stats_views))
    %{
      postings: data,
      # TODO: first_time_authors
    }
  end

  def to_json(posting, conn, stats_clicks, stats_views) do
    {:safe, html} = posting.text |> sanitized_markdown
    %{
      id: posting.id,
      published_at: posting.published_at |> xml_readable_date,
      title: posting.title,
      text: posting.text,
      html: html,
      referenced_urls: posting.referenced_urls |> Poison.decode!,
      permalink: permalink_posting_path(conn, :show, posting.permalink),
      link_clicks: Impressionist.count_clicks(stats_clicks, posting.uid),
      detail_views: Impressionist.count_views(stats_views, posting.uid)
    }
  end
end
