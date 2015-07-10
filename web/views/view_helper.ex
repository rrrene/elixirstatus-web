defmodule ViewHelper do
  # why does `import ElixirStatus.Auth` not work here?
  def current_user(conn), do: ElixirStatus.Auth.current_user(conn)
  def logged_in?(conn), do: ElixirStatus.Auth.logged_in?(conn)
  def admin?(conn), do: ElixirStatus.Auth.admin?(conn)

  def human_readable_date(date) do
    date
  end

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
