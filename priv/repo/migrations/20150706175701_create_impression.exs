defmodule ElixirStatus.Repo.Migrations.CreateImpression do
  use Ecto.Migration

  def change do
    create table(:impressions) do
      add :current_user_id, :integer
      add :path, :string
      add :context, :string
      add :subject_type, :string
      add :subject_uid, :string
      add :accept_language, :string
      add :user_agent, :text
      add :remote_ip, :string
      add :session_hash, :text

      timestamps
    end
  end
end
