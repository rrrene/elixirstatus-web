defmodule ViewHelper do
  use PhoenixHtmlSanitizer, :markdown_html

  alias ElixirStatus.User
  alias ElixirStatus.Date

  @promo_templates ["promo_credo.html", "promo_elixirweekly.html"]
  @twitter_screen_name Application.get_env(:elixir_status, :twitter_screen_name)

  def promo_template_name do
    @promo_templates |> Enum.random()
  end

  def avatar_path(%User{user_name: user_name}), do: avatar_path(user_name)

  def avatar_path(user_name) when is_binary(user_name) do
    "/images/github/#{user_name}.jpg"
  end

  def class_with_error(form, field, base_class) do
    if error_on_field?(form, field) do
      "#{base_class} error"
    else
      base_class
    end
  end

  def error_on_field?(form, field) do
    form.errors
    |> Enum.map(fn({attr, _message}) -> attr end)
    |> Enum.member?(field)
  end

  # why does `import ElixirStatus.Auth` not work here?
  def current_user(conn), do: ElixirStatus.Auth.current_user(conn)
  def logged_in?(conn), do: ElixirStatus.Auth.logged_in?(conn)
  def admin?(conn), do: ElixirStatus.Auth.admin?(conn)

  @doc "Returns a date formatted for humans."
  def human_readable_date(date, use_abbrevs? \\ true) do
    if use_abbrevs? && this_year?(date) do
      cond do
        today?(date) ->
          "Today"
        yesterday?(date) ->
          "Yesterday"
        true ->
          date |> Date.strftime("%e %b")
      end
    else
      date |> Date.strftime("%e %b %Y")
    end
  end

  @doc "Returns a date formatted for RSS clients."
  def xml_readable_date(date) do
    Date.strftime(date, "%e %b %Y %T %z")
  end

  defp this_year?(date), do: date.year == Ecto.DateTime.utc.year

  defp today?(date) do
    now = Ecto.DateTime.utc
    date.day == now.day && date.month == now.month && date.year == now.year
  end

  def yesterday?(date) do
    now = Ecto.DateTime.utc
    difference =ElixirStatus.Date.diff(now, date)
    difference < 2 * 24 * 60 * 60 && difference > 1 * 24 * 60 * 60
  end

  def sanitized_markdown(nil), do: ""

  def sanitized_markdown(text) do
    text
    |> Earmark.to_html
    |> sanitize
  end

  def strip_tags(text) do
    sanitize(text, :strip_tags)
  end

  def twitter_screen_name, do: @twitter_screen_name
end
