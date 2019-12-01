defmodule ElixirStatus.Posting do
  use ElixirStatus.Web, :model

  schema "postings" do
    field(:uid, :string)
    field(:permalink, :string)
    field(:title, :string)
    field(:text, :string)
    field(:scheduled_at, :utc_datetime)
    field(:published_at, :utc_datetime)
    field(:published_tweet_uid, :string)
    field(:public, :boolean, default: false)
    field(:moderation_key, :string)
    field(:awaiting_moderation, :boolean, default: false)
    field(:metadata, :map)

    field(:type, :string)
    field(:referenced_urls, :string)

    timestamps

    belongs_to(:user, ElixirStatus.User)
  end

  @required_fields ~w(user_id uid permalink title text published_at public)a
  @all_fields @required_fields ++ ~w(published_tweet_uid scheduled_at type referenced_urls moderation_key awaiting_moderation metadata)a

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @all_fields)
    |> validate_required(@required_fields)
    |> update_change(:title, &String.strip/1)
    |> validate_length(:title, min: 1)
    |> update_change(:text, &String.strip/1)
    |> validate_length(:text, min: 1)
  end
end
