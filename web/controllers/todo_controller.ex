defmodule TodoApp.TodoController do
  use TodoApp.Web, :controller

  alias TodoApp.{Repo, Todo, User}

  def action(%Plug.Conn{assigns: %{current_user: nil}} = conn, _) do
    put_status(conn, :unauthorized) |> render(TodoApp.AuthView, "401.json", []) |> halt
  end
  def action(%Plug.Conn{params: %{"user_id" => user_id} = params,
    assigns: %{current_user: current_user}} = conn, _) do
    if user_id == to_string(current_user.id) do
      apply(__MODULE__, action_name(conn), [conn, params, Repo.get(User, current_user.id)])
    else
      put_status(conn, :forbidden) |> render(TodoApp.AuthView, "403.json", []) |> halt
    end
  end

  def index(conn, _params, user) do
    todos = Repo.all assoc(user, :todos)
    render(conn, "index.json", todos: todos)
  end

  def create(conn, %{"todo" => todo_params}, user) do
    changeset = user |> build_assoc(:todos) |> Todo.changeset(todo_params)

    case Repo.insert(changeset) do
      {:ok, todo} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", user_todo_path(conn, :show, user, todo))
        |> render("show.json", todo: todo)
      {:error, _changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(TodoApp.ErrorView, "404.json", [])
    end
  end

  def show(conn, %{"id" => id}, user) do
    todo = Repo.get assoc(user, :todos), id
    render(conn, "show.json", todo: todo)
  end

  def update(conn, %{"id" => id, "todo" => todo_params}, user) do
    todo = Repo.get(assoc(user, :todos), id)
    changeset = Todo.changeset(todo, todo_params)

    case Repo.update(changeset) do
      {:ok, todo} ->
        render(conn, "show.json", todo: todo)
      {:error, _changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(TodoApp.ErrorView, "404.json", [])
    end
  end

  def delete(conn, %{"id" => id}, user) do
    todo = Repo.get(assoc(user, :todos), id)
    Repo.delete!(todo)

    send_resp(conn, :no_content, "")
  end
end
