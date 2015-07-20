defmodule ElixirStatus.FeedView do
  use ElixirStatus.Web, :view

  alias ElixirStatus.URL

  def xml_sanitized_inline_markdown(text) do
    {:safe, text} = ViewHelper.sanitized_inline_markdown(text)
    text
  end

  def xml_sanitized_markdown(text) do
    {:safe, text} = ViewHelper.sanitized_markdown(text)
    text
  end

  def to_permalink(conn, posting) do
    permalink_posting_path(conn, :show, posting.permalink)
      |> URL.from_path
  end
end
