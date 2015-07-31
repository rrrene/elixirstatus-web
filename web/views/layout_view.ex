defmodule ElixirStatus.LayoutView do
  use ElixirStatus.Web, :view

  alias ElixirStatus.Posting
  alias ElixirStatus.URL

  def admin_site_switcher do
    Application.get_env(:elixir_status, :admin_site_switcher_html) || ""
  end

  def html_title(assigns) do
    case assigns[:posting] do
      nil -> ElixirStatus.Meta.html_title
      posting -> posting.title
    end
  end

  def og_image_url(assigns) do
    og_image_path(assigns) |> URL.from_path
  end

  defp og_image_path(assigns) do
    case assigns[:posting] do
      nil -> "/images/logo.png"
      %Posting{user: %Ecto.Association.NotLoaded{}} -> "/images/logo.png"
      %Posting{user: user} -> avatar_path(user)
    end
  end
end
