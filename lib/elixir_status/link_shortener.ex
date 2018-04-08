defmodule ElixirStatus.LinkShortener do
  @moduledoc """
    Shortens links.
  """

  alias ElixirStatus.Repo
  alias ElixirStatus.ShortLink

  def to_uid(url) do
    case find_by_url(url) do
      nil -> create_from_url(url).uid
      link -> link.uid
    end
  end

  def to_url(uid) do
    case find_by_uid(uid) do
      nil -> nil
      link -> link.url
    end
  end

  defp create_from_url(url) do
    %ShortLink{uid: ElixirStatus.UID.generate(ShortLink), url: url}
    |> Repo.insert!()
  end

  defp find_by_url(url) do
    Repo.get_by(ShortLink, url: url)
  end

  defp find_by_uid(uid) do
    Repo.get_by(ShortLink, uid: uid)
  end
end
