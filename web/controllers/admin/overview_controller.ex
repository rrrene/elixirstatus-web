defmodule ElixirStatus.Admin.OverviewController do
  use ElixirStatus.Web, :controller

  plug ElixirStatus.Plugs.Admin

  def index(conn, params) do
    page = ElixirStatus.PostingController.get_all(params)
    render(conn, "index.html", postings: page.entries,
                               page_number: page.page_number,
                               total_pages: page.total_pages)
  end
end
