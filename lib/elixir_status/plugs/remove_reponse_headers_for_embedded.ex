defmodule ElixirStatus.RemoveReponseHeadersForEmbedded do
  def init(default), do: default

  def call(conn, _default) do
    header = conn.resp_headers |> List.keyfind("x-frame-options", 0)
    resp_headers = conn.resp_headers |> List.delete(header)

    %Plug.Conn{conn | resp_headers: resp_headers}
  end
end
