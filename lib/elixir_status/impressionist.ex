defmodule ElixirStatus.Impressionist do
  @moduledoc """
    The Impressionist comes into play when we want to record that something
    was looked at.
  """

  import Plug.Conn
  import Ecto.Query, only: [from: 2]

  alias ElixirStatus.Impression
  alias ElixirStatus.Repo

  def count(context, subject_type) do
    query =
      from(
        r in Impression,
        where: r.context == ^context and r.subject_type == ^subject_type,
        select: count(r.id)
      )

    query |> Repo.one()
  end

  def count_sessions(context, subject_type) do
    query =
      from(
        r in Impression,
        where:
          r.context == ^context and r.subject_type == ^subject_type and not is_nil(r.session_hash),
        select: count(r.id)
      )

    query |> Repo.one()
  end

  def count(context, subject_type, subject_uid) do
    query =
      from(
        r in Impression,
        where:
          r.context == ^context and r.subject_type == ^subject_type and
            r.subject_uid == ^subject_uid,
        select: count(r.id)
      )

    query |> Repo.one()
  end

  def count_sessions(context, subject_type, subject_uid) do
    query =
      from(
        r in Impression,
        where:
          r.context == ^context and r.subject_type == ^subject_type and
            r.subject_uid == ^subject_uid and not is_nil(r.session_hash),
        select: count(r.id)
      )

    query |> Repo.one()
  end

  def all(contexts, subject_type) when is_list(contexts) do
    query =
      from(
        r in Impression,
        where: r.context in ^contexts and r.subject_type == ^subject_type,
        select: r
      )

    Repo.all(query)
  end

  def all(context, subject_type, subject_uids) when is_list(subject_uids) do
    query =
      from(
        r in Impression,
        where:
          r.context == ^context and r.subject_type == ^subject_type and
            r.subject_uid in ^subject_uids,
        select: r
      )

    Repo.all(query)
  end

  # These functions load stats in bulk
  #
  def stats_clicks(postings) do
    contexts = postings |> Enum.map(&"postings:#{&1.uid}")
    all(contexts, "short_link")
  end

  def stats_views(postings) do
    posting_uids = postings |> Enum.map(& &1.uid)
    all("detail", "posting", posting_uids)
  end

  # These functions count the lists given with `all`
  #
  def count_clicks(stats_clicks, uid) do
    stats_clicks
    |> List.wrap()
    |> Enum.filter(&(&1.context == "postings:#{uid}" && &1.subject_type == "short_link"))
    |> Enum.count()
  end

  def urls_sorted_by_most_clicks(stats_clicks, uid) do
    stats_clicks
    |> List.wrap()
    |> Enum.filter(&(&1.context == "postings:#{uid}" && &1.subject_type == "short_link"))
    |> Enum.group_by(& &1.subject_uid)
    |> Map.values()
    |> Enum.sort_by(fn list -> Enum.count(list) end)
    |> Enum.map(&list_to_url/1)
    |> Enum.reverse()
  end

  defp list_to_url(nil), do: nil
  defp list_to_url([]), do: nil

  defp list_to_url(list) do
    impression = list |> List.last()

    impression.subject_uid
    |> ElixirStatus.LinkShortener.to_url()
  end

  def count_views(stats_views, uid) do
    stats_views
    |> List.wrap()
    |> Enum.filter(
      &(&1.context == "detail" && &1.subject_type == "posting" && &1.subject_uid == uid)
    )
    |> Enum.count()
  end

  @doc """
    Directly records an impression. This is supposed to be called from inside
    Phoenix.
  """
  def record(conn, "" <> context) do
    record(conn, %{"context" => context})
  end

  def record(conn, params) do
    spawn(fn -> create_impression(conn, params) end)
    conn
  end

  def record(conn, "" <> context, subject_type, subject_uid) do
    record(conn, %{
      "context" => context,
      "subject_type" => subject_type,
      "subject_uid" => subject_uid
    })
  end

  defp create_impression(conn, impression_params) do
    impression_params =
      impression_params
      |> extract_valid_params
      |> to_create_params(conn)

    changeset = Impression.changeset(%Impression{}, impression_params)
    if changeset.valid?, do: Repo.insert!(changeset)

    conn
  end

  defp extract_valid_params(%{
         "context" => context,
         "subject_type" => subject_type,
         "subject_uid" => subject_uid
       }) do
    %{
      "context" => String.strip(context || ""),
      "subject_type" => String.strip(subject_type || ""),
      "subject_uid" => subject_uid
    }
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
      remote_ip: conn.remote_ip |> Tuple.to_list() |> Enum.join(".")
    }
  end
end
