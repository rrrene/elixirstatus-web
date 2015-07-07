defmodule ElixirStatus.Repo.Migrations.CreateShortLink do
  use Ecto.Migration

  def change do
    create table(:short_links) do
      add :uid, :string
      add :url, :string

      timestamps
    end
    create index(:short_links, ["uid"])
    create index(:short_links, ["url"])
  end
end
