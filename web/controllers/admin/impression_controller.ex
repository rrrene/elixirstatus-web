defmodule ElixirStatus.Admin.ImpressionController do
  use ElixirStatus.Web, :controller

  alias ElixirStatus.Impression

  plug ElixirStatus.Plugs.Admin

  @layout {ElixirStatus.LayoutView, "admin.html"}

  def index(conn, params) do
    render conn, "index.html", layout: @layout,
                                impressions: get_all(params)
  end

  defp get_all(%{"context" => context, "subject_type" => subject_type, "subject_uid" => subject_uid}) do
    query = from p in Impression,
                  where: p.context == ^context and
                          p.subject_type == ^subject_type and
                          p.subject_uid == ^subject_uid,
                  order_by: [desc: :inserted_at]
    query |> Repo.all
  end

  defp get_all(%{"context" => context, "subject_type" => subject_type}) do
    query = from p in Impression,
                  where: p.context == ^context and p.subject_type == ^subject_type,
                  order_by: [desc: :inserted_at]
    query |> Repo.all
  end

  defp get_all(%{"subject_type" => subject_type, "subject_uid" => subject_uid}) do
    query = from p in Impression,
                  where: p.subject_type == ^subject_type and p.subject_uid == ^subject_uid,
                  order_by: [desc: :inserted_at]
    query |> Repo.all
  end

  defp get_all(params \\ %{}) do
    query = from p in Impression,
                  order_by: [desc: :inserted_at]
    query |> Repo.all
  end

end
