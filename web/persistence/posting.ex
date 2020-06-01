defmodule ElixirStatus.Persistence.Posting do
  import Ecto.Query, only: [from: 2]

  alias ElixirStatus.Repo
  alias ElixirStatus.Posting

  @postings_per_page 20

  def find_by_id(id) do
    query = from(p in Posting, where: p.id == ^id)

    query
    |> Ecto.Query.preload(:user)
    |> Repo.one()
  end

  def find_by_moderation_key(moderation_key) do
    query = from(p in Posting, where: p.moderation_key == ^moderation_key)

    query
    |> Ecto.Query.preload(:user)
    |> Repo.one()
  end

  def find_by_permalink(permalink) do
    String.split(permalink, "-") |> Enum.at(0) |> find_by_uid
  end

  @doc "Returns the posting with the given +uid+."
  def find_by_uid(uid) do
    query = from(p in Posting, where: p.uid == ^uid)
    query |> Ecto.Query.preload(:user) |> Repo.one()
  end

  def published_by_user(user) do
    published(%{"user_id" => user.id}, user, false)
  end

  @doc "Returns the latest postings."
  def published, do: published(%{}, nil, false)

  def published(params, current_user, admin?) do
    params = Map.put(params, :page_size, params["page_size"] || @postings_per_page)

    query_for(params, current_user, admin?)
    |> Ecto.Query.preload(:user)
    |> Repo.paginate(params)
  end

  defp query_for(%{"q" => q}, nil, false) do
    term = "%" <> String.replace(q, " ", "%") <> "%"

    from(
      p in Posting,
      where: p.public == ^true and (like(p.title, ^term) or like(p.text, ^term)),
      order_by: [desc: :published_at]
    )
  end

  defp query_for(%{"q" => q}, current_user, false) do
    term = "%" <> String.replace(q, " ", "%") <> "%"

    from(
      p in Posting,
      where:
        (p.public == ^true or p.user_id == ^current_user.id) and
          (like(p.title, ^term) or like(p.text, ^term)),
      order_by: [desc: :published_at]
    )
  end

  defp query_for(%{"q" => q}, _current_user, true) do
    term = "%" <> String.replace(q, " ", "%") <> "%"

    from(
      p in Posting,
      where: like(p.title, ^term) or like(p.text, ^term),
      order_by: [desc: :published_at]
    )
  end

  defp query_for(%{"user_id" => user_id}, _, _) do
    from(
      p in Posting,
      where: p.user_id == ^user_id,
      order_by: [desc: :published_at]
    )
  end

  # not logged in, no admin
  defp query_for(_, nil, false) do
    from(
      p in Posting,
      where: p.public == ^true,
      order_by: [desc: :published_at]
    )
  end

  # logged in, no admin
  defp query_for(_, current_user, false) do
    from(
      p in Posting,
      where: p.public == ^true or p.user_id == ^current_user.id,
      order_by: [desc: :published_at]
    )
  end

  # admin
  defp query_for(_, _current_user, true) do
    from(p in Posting, order_by: [desc: :published_at])
  end

  @doc "Update the tweet_uid for an existing posting"
  def update_published_tweet_uid(posting, tweet_uid) do
    posting
    |> ElixirStatus.Posting.changeset(%{published_tweet_uid: tweet_uid})
    |> Repo.update!()
  end

  def unpublish(posting) do
    posting
    |> ElixirStatus.Posting.changeset(%{public: false})
    |> Repo.update!()
  end

  def mark_as_spam(posting) do
    metadata = posting.metadata || %{}
    metadata = Map.put(metadata, "marked_as_spam_at", Ecto.DateTime.utc())

    attributes = %{public: false, awaiting_moderation: false, metadata: metadata}

    posting
    |> ElixirStatus.Posting.changeset(attributes)
    |> Repo.update!()
  end

  def republish(posting) do
    posting
    |> ElixirStatus.Posting.changeset(%{public: true})
    |> Repo.update!()
  end

  def publish_moderated(posting) do
    metadata = posting.metadata || %{}
    metadata = Map.put(metadata, "moderated_at", Ecto.DateTime.utc())

    attributes = %{public: true, awaiting_moderation: false, metadata: metadata}

    posting
    |> ElixirStatus.Posting.changeset(attributes)
    |> Repo.update!()
  end

  def require_moderation(posting, reasons) do
    metadata = posting.metadata || %{}
    metadata = Map.put(metadata, "moderation_reasons", reasons)

    attributes = %{public: false, awaiting_moderation: true, metadata: metadata}

    posting
    |> ElixirStatus.Posting.changeset(attributes)
    |> Repo.update!()
  end
end
