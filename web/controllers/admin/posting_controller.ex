defmodule ElixirStatus.Admin.PostingController do
  use ElixirStatus.Web, :controller

  alias ElixirStatus.Posting

  plug ElixirStatus.Plugs.Admin

  @layout {ElixirStatus.LayoutView, "admin.html"}

  def index(conn, params) do
    params = Map.put(params, "page_size", 200)
    page = ElixirStatus.Persistence.Posting.published(params, nil, true)
    count = Repo.one(from r in Posting,
                      where: r.public == ^true,
                      select: count(r.id))

    contexts =
      page.entries
      |> Enum.map(&("postings:#{&1.uid}"))
    stats_clicks =
      ElixirStatus.Impressionist.all(contexts, "short_link")

    posting_uids =
      page.entries
      |> Enum.map(&(&1.uid))
    stats_views =
      ElixirStatus.Impressionist.all("detail", "posting", posting_uids)

    render conn, "index.html", layout: @layout,
                                count: count,
                                postings: page.entries,
                                page_number: page.page_number,
                                total_pages: page.total_pages,
                                stats_clicks: stats_clicks,
                                stats_views: stats_views
  end
end
