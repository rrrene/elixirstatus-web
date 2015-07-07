defmodule ElixirStatus.ImpressionController do
  use ElixirStatus.Web, :controller

  alias ElixirStatus.Impressionist

  def create(conn, impression_params) do
    conn
      |> Impressionist.record(impression_params)
      |> json(%{"ok" => true})
  end
end
