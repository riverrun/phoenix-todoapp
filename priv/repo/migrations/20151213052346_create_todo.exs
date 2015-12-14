defmodule TodoApp.Repo.Migrations.CreateTodo do
  use Ecto.Migration

  def change do
    create table(:todos) do
      add :title, :string
      add :notes, :string
      add :body, :text
      add :user_id, references(:users)

      timestamps
    end
    create index(:todos, [:user_id])

  end
end
