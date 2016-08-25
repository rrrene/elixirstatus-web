defmodule ElixirStatus.ConnLoginHelper do
  defmacro __using__(_opts) do
    quote do
      def assert_login_required(conn) do
        assert html_response(conn, 302)
      end

      def assert_same_user_required(conn) do
        assert html_response(conn, 302)
      end

      def current_user(conn) do
        conn.assigns[:current_user]
      end

      def logged_in_conn do
        conn = get build_conn(), "/auth"
        assert html_response(conn, 302)
        conn
      end

      def logged_out_conn do
        conn = get build_conn(), "/auth/sign_out"
        assert html_response(conn, 302)
        conn
      end

      def logged_in?(conn) do
        html_response(conn, 200) =~ ~r/\<meta name\=\"logged_in_as\"/
      end
    end
  end
end
