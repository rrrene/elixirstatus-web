defmodule ViewHelper do
  use Timex

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
  def human_readable_date(date) do
    {:ok, readable} = if this_year?(date) do
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

  def sanitize(text) do
    HtmlSanitizeEx.basic_html(text)
  end

  def sanitized_markdown(nil), do: ""

  def sanitized_markdown(text) do
    text
      |> Earmark.to_html
      |> HtmlSanitizeEx.basic_html
      |> Phoenix.HTML.raw
  end

  def sanitized_inline_markdown(text) do
    {:safe, text} = sanitized_markdown(text)
    text
      |> String.replace(~r/(<\/?p>)/, "")
      |> Phoenix.HTML.raw
  end
end
