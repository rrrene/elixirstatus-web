defmodule ViewHelper do
  use Timex
  use Phoenix.HTML.Sanitizer, :basic_html

  alias ElixirStatus.User

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
    Enum.map(form.errors, fn({attr, _message}) -> attr end)
      |> Enum.member?(field)
  end

  # why does `import ElixirStatus.Auth` not work here?
  def current_user(conn), do: ElixirStatus.Auth.current_user(conn)
  def logged_in?(conn), do: ElixirStatus.Auth.logged_in?(conn)
  def admin?(conn), do: ElixirStatus.Auth.admin?(conn)

  @doc "Returns a date formatted for humans."
  def human_readable_date(date, use_abbrevs \\ true) do
    {:ok, readable} = if use_abbrevs && this_year?(date) do
                        if today?(date) do
                          {:ok, "Today"}
                        else
                          DateFormat.format(date, "%e %b", :strftime)
                        end
                      else
                        DateFormat.format(date, "%e %b %Y", :strftime)
                      end
    readable
  end

  @doc "Returns a date formatted for RSS clients."
  def xml_readable_date(date) do
    {:ok, readable} = DateFormat.format(date, "%e %b %Y %T %z", :strftime)
    readable
  end

  defp this_year?(date), do: date.year == Ecto.DateTime.utc.year

  defp today?(date) do
    now = Ecto.DateTime.utc
    date.day == now.day && date.month == now.month && date.year == now.year
  end

  def sanitized_markdown(nil), do: ""

  def sanitized_markdown(text) do
    text
      |> Earmark.to_html
      |> sanitize
  end

  def sanitized_inline_markdown(text) do
    {:safe, text} = sanitized_markdown(text)
    text
      |> String.replace(~r/(<\/?p>)/, "")
      |> Phoenix.HTML.raw
  end

  @twitter_screen_name Application.get_env(:elixir_status, :twitter_screen_name)
  def twitter_screen_name, do: @twitter_screen_name
end
