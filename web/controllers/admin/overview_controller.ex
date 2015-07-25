defmodule ElixirStatus.Admin.OverviewController do
  use ElixirStatus.Web, :controller

  plug ElixirStatus.Plugs.Admin

  @layout {ElixirStatus.LayoutView, "admin.html"}

  def index(conn, params) do
    page = ElixirStatus.PostingController.get_all(params)
    render(conn, "index.html", layout: @layout,
                                postings: page.entries,
                                page_number: page.page_number,
                                total_pages: page.total_pages)
  end
end
