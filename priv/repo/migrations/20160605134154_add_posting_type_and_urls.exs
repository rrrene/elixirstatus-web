defmodule ElixirStatus.Repo.Migrations.AddPostingTypeAndUrls do
  use Ecto.Migration

  def change do
    alter table(:postings) do
      add :type, :string
      add :referenced_urls, :text
    end
  end
end
