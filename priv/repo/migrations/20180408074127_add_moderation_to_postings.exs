defmodule ElixirStatus.Repo.Migrations.AddModerationToPostings do
  use Ecto.Migration

  def change do
    alter table(:postings) do
      add(:moderation_key, :string)
      add(:awaiting_moderation, :boolean, default: false)
      add(:metadata, :map)
    end
  end
end
