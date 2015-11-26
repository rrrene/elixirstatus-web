defmodule ElixirStatus.Admin.PostingController do
  use ElixirStatus.Web, :controller
  use Timex

  alias  ElixirStatus.Posting

  plug ElixirStatus.Plugs.Admin

  @layout {ElixirStatus.LayoutView, "admin.html"}

  def index(conn, params) do
    page = ElixirStatus.PostingController.get_all(params)
    count = Repo.one(from r in Posting,
                      where: r.public == ^true,
                      select: count(r.id))
    render conn, "index.html", layout: @layout,
                                count: count,
                                postings: page.entries,
                                page_number: page.page_number,
                                total_pages: page.total_pages
  end


  def recent(conn, _params) do
    from_date = Date.now
    until_date = days_earlier(28)
    query = from p in Posting,
                  where: p.public == ^true and
                  p.published_at <= ^from_date and p.published_at > ^until_date,
                  order_by: [desc: :published_at]
    postings = query |> Ecto.Query.preload(:user) |> Repo.all

    render conn, "recent.json", postings: postings
  end

  defp days_earlier(count) do
    Date.now
    |> Date.subtract(Time.to_timestamp(count, :days))
  end
end
