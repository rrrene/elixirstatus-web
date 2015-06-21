defmodule ElixirStatus.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :full_name, :string
      add :email, :string
      add :provider, :string
      add :user_name, :string

      timestamps
    end

  end
end
