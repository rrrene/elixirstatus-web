defmodule ElixirStatus.LayoutView do
  use ElixirStatus.Web, :view

  alias ElixirStatus.Posting
  alias ElixirStatus.URL

  def og_image_url(assigns) do
    og_image_path(assigns) |> URL.from_path
  end

  defp og_image_path(assigns) do
    case assigns[:posting] do
      nil -> "/images/logo.png"
      %Posting{user: %Ecto.Association.NotLoaded{}} -> "/images/logo.png"
      %Posting{user: user} -> "/images/github/#{user.user_name}.jpg"
    end
  end
end
