defmodule ViewHelper do

  def current_user(conn), do: conn.assigns[:current_user]

  def human_readable_date(date) do
    date
  end

  def logged_in?(conn), do: !is_nil(current_user(conn))

  def sanitize(text) do
    HtmlSanitizeEx.basic_html(text)
  end

  def sanitized_markdown(text) do
    text
      |> Earmark.to_html
      |> HtmlSanitizeEx.basic_html
      |> Phoenix.HTML.raw
  end
end
