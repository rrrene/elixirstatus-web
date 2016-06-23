defmodule ElixirStatus.Admin.PostingView do
  use ElixirStatus.Web, :view

  def to_short_uid(permalink) do
    "/p/#{permalink}"
      |> ElixirStatus.URL.from_path
      |> ElixirStatus.LinkShortener.to_uid
  end

end
