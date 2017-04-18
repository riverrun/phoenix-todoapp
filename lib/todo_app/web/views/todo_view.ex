defmodule TodoApp.Web.TodoView do
  use TodoApp.Web, :view
  alias TodoApp.Web.TodoView

  def render("index.json", %{todos: todos}) do
    %{data: render_many(todos, TodoView, "todo.json")}
  end

  def render("show.json", %{todo: todo}) do
    %{data: render_one(todo, TodoView, "todo.json")}
  end

  def render("todo.json", %{todo: todo}) do
    %{id: todo.id,
      title: todo.title,
      body: todo.body,
      notes: todo.notes,
      user_id: todo.user_id}
  end
end
