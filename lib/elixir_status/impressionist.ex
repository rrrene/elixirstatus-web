defmodule ElixirStatus.Impressionist do
  @moduledoc """
    The Impressionist comes into play when we want to record that something
    was looked at.
  """

  import Plug.Conn
  alias ElixirStatus.Impression
  alias ElixirStatus.Repo

  @doc """
    Directly records an impression. This is supposed to be called from inside
    Phoenix.
  """
  def record(conn, "" <> context) do
    record(conn, %{"context" => context})
  end

  def record(conn, params) do
    spawn fn -> create_impression(conn, params) end
  end

  def record(conn, "" <> context, subject_type, subject_uid) do
    record(conn, %{"context" => context, "subject_type" => subject_type, "subject_uid" => subject_uid})
  end


  defp create_impression(conn, impression_params) do
    impression_params = impression_params
                      |> extract_valid_params
                      |> to_create_params(conn)

    IO.inspect {:impression_params, impression_params}
    changeset = Impression.changeset(%Impression{}, impression_params)

    if changeset.valid?, do: Repo.insert!(changeset)
    conn
  end

  defp extract_valid_params(%{"context" => context, "subject_type" => subject_type, "subject_uid" => subject_uid}) do
    %{"context" => String.strip(context || ""), "subject_type" => String.strip(subject_type || ""), "subject_uid" => subject_uid}
  end

  defp extract_valid_params(%{"context" => context}) do
    %{"context" => String.strip(context || "")}
  end

  defp extract_valid_params(_) do
    %{}
  end

  defp to_create_params(params, conn) do
    %{
      current_user_id: get_session(conn, :current_user_id),
      path: conn.path_info |> Enum.join("/"),
      context: params["context"],
      subject_type: params["subject_type"],
      subject_uid: params["subject_uid"],
      user_agent: get_req_header(conn, "user-agent") |> Enum.at(0),
      session_hash: conn.cookies["_elixir_status_key"],
      accept_language: get_req_header(conn, "accept-language") |> Enum.at(0),
      remote_ip: conn.remote_ip |> Tuple.to_list |> Enum.join(".")
    }
  end
end
