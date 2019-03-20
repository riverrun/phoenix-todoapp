defmodule TodoApp.Jobs do
  @moduledoc """
  The Jobs context.
  """

  import Ecto
  import Ecto.Query, warn: false

  alias TodoApp.{Accounts.User, Jobs.Todo, Repo}

  @type changeset_error :: {:error, Ecto.Changeset.t()}

  @doc """
  Returns a list of todos for the user.
  """
  @spec list_todos(User.t()) :: [Todo.t()]
  def list_todos(user) do
    Repo.all(assoc(user, :todos))
  end

  @doc """
  Gets any todo.
  """
  @spec get_todo(integer) :: Todo.t() | nil
  def get_todo(id), do: Repo.get(Todo, id)

  @doc """
  Gets a certain user's todo.
  """
  @spec get_user_todo(User.t(), integer) :: Todo.t() | nil
  def get_user_todo(%User{id: user_id}, id) do
    Todo
    |> where([t], t.id == ^id and t.user_id == ^user_id)
    |> Repo.one()
  end

  @doc """
  Gets a todo based on the params.
  """
  @spec get_by(map) :: Todo.t() | nil
  def get_by(attrs) do
    Repo.get_by(Todo, attrs)
  end

  @doc """
  Creates a todo.
  """
  @spec create_todo(User.t(), map) :: {:ok, Todo.t()} | changeset_error
  def create_todo(user, attrs \\ %{}) do
    user
    |> build_assoc(:todos)
    |> Todo.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a todo.
  """
  @spec update_todo(Todo.t(), map) :: {:ok, Todo.t()} | changeset_error
  def update_todo(%Todo{} = todo, attrs) do
    todo
    |> Todo.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a todo.
  """
  @spec delete_todo(Todo.t()) :: {:ok, Todo.t()} | changeset_error
  def delete_todo(%Todo{} = todo) do
    Repo.delete(todo)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking todo changes.
  """
  @spec change_todo(Todo.t()) :: Ecto.Changeset.t()
  def change_todo(%Todo{} = todo) do
    Todo.changeset(todo, %{})
  end
end
