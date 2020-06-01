defmodule ElixirStatus.Repo.Migrations.UpdatePostingText do
  use Ecto.Migration

  def change do
    alter table(:postings) do
      modify :text, :"TEXT CHARACTER SET utf8mb4"
      modify :title, :"TEXT CHARACTER SET utf8mb4"
    end
  end
end
