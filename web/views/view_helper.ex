defmodule ViewHelper do
  def logged_in?(assigns) do
    !is_nil(assigns[:current_user])
  end

  def sanitize(text) do
    HtmlSanitizeEx.basic_html(text)
  end
end
