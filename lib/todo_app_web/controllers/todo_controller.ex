defmodule TodoAppWeb.TodoController do
  use TodoAppWeb, :controller

  import TodoAppWeb.Authorize
  alias TodoApp.Jobs
  alias TodoApp.Jobs.Todo

  action_fallback TodoAppWeb.FallbackController

  def action(conn, _), do: auth_action_id(conn, __MODULE__)

  def index(conn, _params, user) do
    todos = Jobs.list_todos(user)
    render(conn, "index.json", todos: todos)
  end

  def create(conn, %{"todo" => todo_params}, user) do
    with {:ok, %Todo{} = todo} <- Jobs.create_todo(user, todo_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", user_todo_path(conn, :show, user.id, todo))
      |> render("show.json", todo: todo)
    end
  end

  def show(conn, %{"id" => id}, user) do
    todo = Jobs.get_todo(user, id)
    render(conn, "show.json", todo: todo)
  end

  def update(conn, %{"id" => id, "todo" => todo_params}, user) do
    todo = Jobs.get_todo(user, id)

    with {:ok, %Todo{} = todo} <- Jobs.update_todo(todo, todo_params) do
      render(conn, "show.json", todo: todo)
    end
  end

  def delete(conn, %{"id" => id}, user) do
    todo = Jobs.get_todo(user, id)
    with {:ok, %Todo{}} <- Jobs.delete_todo(todo) do
      send_resp(conn, :no_content, "")
    end
  end
end
