defmodule ElixirStatus.Locale do
  import Plug.Conn

  def init(opts), do: nil

  def call(conn, _opts) do
    case conn.params["locale"] || get_session(conn, :locale) do
      nil     -> conn
      locale  ->
        Gettext.put_locale(ElixirStatus.Gettext, locale)
        conn |> put_session(:locale, locale)
    end
  end
end
