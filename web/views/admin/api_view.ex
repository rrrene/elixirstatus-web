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

  def to_json(%ElixirStatus.User{} = user) do
    %{
      full_name: user.full_name,
      email: user.email,
      provider: user.provider,
      user_name: user.user_name,
      twitter_handle: user.twitter_handle,
    }
  end
  def to_json(posting, conn, stats_clicks, stats_views) do
    {:safe, html} = posting.text |> sanitized_markdown
    %{
      id: posting.id,
      published_at: posting.published_at |> xml_readable_date(),
      type: posting.type,
      author: posting.user |> to_json(),
      title: posting.title,
      text: html |> to_text(),
      html: html,
      urls: Impressionist.urls_sorted_by_most_clicks(stats_clicks, posting.uid),
      permalink: permalink_posting_path(conn, :show, posting.permalink),
      link_clicks: Impressionist.count_clicks(stats_clicks, posting.uid),
      detail_views: Impressionist.count_views(stats_views, posting.uid)
    }
  end

  defp to_text(html) do
    html
    |> String.replace("</p>", "\n\n")
    |> HtmlSanitizeEx.strip_tags()
  end
end
