defmodule TodoApp.Repo.Migrations.CreateTodos do
  use Ecto.Migration

  def change do
    create table(:todos) do
      add :title, :string
      add :body, :string
      add :notes, :string
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end

    create index(:todos, [:user_id])
  end
end
