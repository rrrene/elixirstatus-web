defmodule ElixirStatus.Repo.Migrations.CreatePosting do
  use Ecto.Migration

  def change do
    create table(:postings) do
      add :user_id, :integer
      add :uid, :string
      add :permalink, :string
      add :title, :string
      add :text, :text
      add :scheduled_at, :datetime
      add :published_at, :datetime
      add :public, :boolean, default: false

      timestamps
    end
    create index(:postings, ["uid"])
  end
end
