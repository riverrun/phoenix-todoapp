defmodule TodoApp.TodoController do
  use TodoApp.Web, :controller

  alias TodoApp.Todo
  alias TodoApp.User

  def action(%Plug.Conn{assigns: %{current_user: nil}} = conn, _) do
    render(conn, TodoApp.ErrorView, "401.json", [])
  end
  def action(%Plug.Conn{params: params, assigns: %{current_user: current_user}} = conn, _) do
    apply(__MODULE__, action_name(conn), [conn, params, Repo.get(User, current_user.id)])
  end

  def index(conn, _params, user) do
    todos = Repo.all(user_todos(user))
    render(conn, "index.json", todos: todos)
  end

  def create(conn, %{"todo" => todo_params}, user) do
    changeset = user |> build(:todos) |> Todo.changeset(todo_params)

    case Repo.insert(changeset) do
      {:ok, todo} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", user_todo_path(conn, :show, user, todo))
        |> render("show.json", todo: todo)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(TodoApp.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, user) do
    todo = Repo.get(user_todos(user), id)
    render(conn, "show.json", todo: todo)
  end

  def update(conn, %{"id" => id, "todo" => todo_params}, user) do
    todo = Repo.get(user_todos(user), id)
    changeset = Todo.changeset(todo, todo_params)

    case Repo.update(changeset) do
      {:ok, todo} ->
        render(conn, "show.json", todo: todo)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(TodoApp.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, user) do
    todo = Repo.get(user_todos(user), id)
    Repo.delete!(todo)

    send_resp(conn, :no_content, "")
  end

  defp user_todos(user) do
    assoc(user, :todos)
  end
end
