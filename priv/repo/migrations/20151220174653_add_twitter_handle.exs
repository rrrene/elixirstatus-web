defmodule ElixirStatus.Repo.Migrations.AddTwitterHandle do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :twitter_handle, :string
    end
  end
end
