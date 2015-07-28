defmodule ElixirStatus.Admin.OverviewController do
  use ElixirStatus.Web, :controller

  plug ElixirStatus.Plugs.Admin

  @base_url Application.get_env(:elixir_status, :base_url)
  @iframe_url Application.get_env(:elixir_status, :admin_overview_iframe_url)
  @layout {ElixirStatus.LayoutView, "admin.html"}

  def index(conn, params) do
    page = ElixirStatus.PostingController.get_all(params)
    render conn, "index.html", layout: @layout,
                                postings: page.entries,
                                page_number: page.page_number,
                                total_pages: page.total_pages,
                                base_url: @base_url,
                                iframe_url: @iframe_url
  end
end
