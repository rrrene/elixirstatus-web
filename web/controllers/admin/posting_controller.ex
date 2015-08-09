defmodule ElixirStatus.Admin.PostingController do
  use ElixirStatus.Web, :controller

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
                                total_pages: page.total_pages,
                                base_url: @base_url,
                                iframe_url: @iframe_url
  end
end
