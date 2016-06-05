defmodule ElixirStatus.PostingView do
  use ElixirStatus.Web, :view

  def decode_urls(nil), do: []
  def decode_urls(string) do
    string |> Poison.decode!
  end

  def humanize_type("blog_post"), do: "Blog post"
  def humanize_type("project_update"), do: "Project update"
  def humanize_type(_), do: "Other"

end
