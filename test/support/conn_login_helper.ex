defmodule ElixirStatus.ConnLoginHelper do
  defmacro __using__(_opts) do
    quote do
      def logged_in_conn do
        conn = get conn(), "/auth"
        assert html_response(conn, 302)
        conn
      end

      def logged_in?(conn) do
        html_response(conn, 200) =~ ~r/\<meta name\=\"logged_in_as\"/
      end
    end
  end
end
