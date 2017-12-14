defmodule TodoApp.Jobs do
  import Ecto
  import Ecto.Query, warn: false
  alias TodoApp.Repo
  alias TodoApp.Jobs.Todo

  def list_todos do
    Repo.all(Todo)
  end

  def list_todos(user) do
    Repo.all(assoc(user, :todos))
  end

  def get_todo(id), do: Repo.get(Todo, id)

  def get_todo(user, id), do: Repo.get(assoc(user, :todos), id)

  def get_by(attrs) do
    Repo.get_by(Todo, attrs)
  end

  def create_todo(user, attrs \\ %{}) do
    user
    |> build_assoc(:todos)
    |> Todo.todo_changeset(attrs)
    |> Repo.insert()
  end

  def update_todo(%Todo{} = todo, attrs) do
    todo
    |> Todo.todo_changeset(attrs)
    |> Repo.update()
  end

  def delete_todo(%Todo{} = todo) do
    Repo.delete(todo)
  end

  def change_todo(%Todo{} = todo) do
    Todo.todo_changeset(todo, %{})
  end
end
