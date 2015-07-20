defmodule ElixirStatus.Repo.Migrations.AddPublishedTweetUidToPostings do
  use Ecto.Migration

  def change do
    alter table(:postings) do
      add :published_tweet_uid, :string
    end
  end
end
