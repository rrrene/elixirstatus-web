defmodule ElixirStatus.Repo.Migrations.AddGithubMetadataToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add(:github_metadata, :map)
    end
  end
end
