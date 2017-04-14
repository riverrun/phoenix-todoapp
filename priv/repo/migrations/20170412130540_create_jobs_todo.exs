defmodule TodoApp.Repo.Migrations.CreateTodoApp.Jobs.Todo do
  use Ecto.Migration

  def change do
    create table(:jobs_todos) do
      add :title, :string
      add :body, :string
      add :notes, :string
      add :user_id, references(:accounts_users, on_delete: :nothing)

      timestamps()
    end

    create index(:jobs_todos, [:user_id])
  end
end
