defmodule ElixirStatus.Admin.OverviewView do
  use ElixirStatus.Web, :view


  def to_short_uid(permalink) do
    uid = "/p/#{permalink}"
            |> ElixirStatus.URL.from_path
            |> ElixirStatus.LinkShortener.to_uid
  end
end
