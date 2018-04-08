defmodule ElixirStatus.Admin.ApiController do
  use ElixirStatus.Web, :controller

  alias ElixirStatus.Posting
  alias ElixirStatus.Date

  def recent(conn, _params) do
    from_date = Ecto.DateTime.utc()
    until_date = Date.days_ago(30)

    query =
      from(
        p in Posting,
        where:
          p.public == ^true and not is_nil(p.published_tweet_uid) and p.published_at <= ^from_date and
            p.published_at > ^until_date,
        order_by: [desc: :published_at]
      )

    postings =
      query
      |> Ecto.Query.preload(:user)
      |> Repo.all()

    stats_clicks = ElixirStatus.Impressionist.stats_clicks(postings)
    stats_views = ElixirStatus.Impressionist.stats_views(postings)

    render(
      conn,
      "recent.json",
      postings: postings,
      stats_clicks: stats_clicks,
      stats_views: stats_views
    )
  end
end
