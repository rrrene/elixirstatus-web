defmodule ElixirStatus.Repo.Migrations.AddIndexForPostingsAndUsers do
  use Ecto.Migration

  def change do
    create index(:postings, ["public", "published_at"])
    create index(:users, ["provider", "user_name"])
  end
end
