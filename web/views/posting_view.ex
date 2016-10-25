defmodule ElixirStatus.PostingView do
  use ElixirStatus.Web, :view

  @choosable_types [
    "blog_post",
    "conference",
    "meetup",
    "project_update",
    "video",
    ""]

  def choosable_types do
    #["Blog post": "blog_post", "Project update": "project_update", "Meetup": "meetup", "Video": "video", "Other": ""]
    @choosable_types
    |> Enum.map(&({humanize_type(&1),&1}))
  end

  def decode_urls(nil), do: []
  def decode_urls(string) do
    string |> Poison.decode!
  end

  def humanize_type("blog_post"), do: "Blog post"
  def humanize_type("conference"), do: "Conference"
  def humanize_type("meetup"), do: "Meetup"
  def humanize_type("project_update"), do: "Project update"
  def humanize_type("video"), do: "Video"
  def humanize_type(_), do: "Misc"

end
