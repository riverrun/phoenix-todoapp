defmodule TodoApp.Repo.Migrations.CreateTodoApp.Accounts.User do
  use Ecto.Migration

  def change do
    create table(:accounts_users) do
      add :email, :string
      add :password_hash, :string

      timestamps()
    end

    create unique_index :accounts_users, [:email]
  end
end
