defmodule ElixirStatus.Persistence.Posting do
  import Ecto.Query, only: [from: 2]

  alias ElixirStatus.Repo
  alias ElixirStatus.Posting

  @postings_per_page          20

  def find_by_id(id) do
    query = from(p in Posting, where: p.id == ^id)
    query |> Ecto.Query.preload(:user) |> Repo.one
  end

  def find_by_permalink(permalink) do
    String.split(permalink, "-") |> Enum.at(0) |> find_by_uid
  end

  @doc "Returns the posting with the given +uid+."
  def find_by_uid(uid) do
    query = from(p in Posting, where: p.uid == ^uid)
    query |> Ecto.Query.preload(:user) |> Repo.one
  end

  def published_by_user(user) do
    published(%{"user_id" => user.id})
  end

  @doc "Returns the latest postings."
  def published(params \\ %{}) do
    params = Map.put(params, :page_size, params["page_size"] || @postings_per_page)
    query_for(params) |> Ecto.Query.preload(:user) |> Repo.paginate(params)
  end

  defp query_for(%{"q" => q}) do
    term = "%" <> String.replace(q, " ", "%") <> "%"
    from p in Posting, where: p.public == ^true and (like(p.title, ^term) or like(p.text, ^term)),
                        order_by: [desc: :published_at]
  end
  defp query_for(%{"user_id" => user_id}) do
    from p in Posting, where: p.public == ^true and p.user_id == ^user_id,
                        order_by: [desc: :published_at]
  end
  defp query_for(_) do
    from p in Posting, where: p.public == ^true,
                        order_by: [desc: :published_at]
  end

  @doc "Update the tweet_uid for an existing posting"
  def update_published_tweet_uid(posting, tweet_uid) do
    posting
    |> ElixirStatus.Posting.changeset(%{published_tweet_uid: tweet_uid})
    |> Repo.update!
  end

end