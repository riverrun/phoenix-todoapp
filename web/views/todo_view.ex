defmodule TodoApp.TodoView do
  use TodoApp.Web, :view

  def render("index.json", %{todos: todos}) do
    %{data: render_many(todos, TodoApp.TodoView, "todo.json")}
  end

  def render("show.json", %{todo: todo}) do
    %{data: render_one(todo, TodoApp.TodoView, "todo.json")}
  end

  def render("todo.json", %{todo: todo}) do
    %{id: todo.id,
      user_id: todo.user_id,
      title: todo.title,
      notes: todo.notes,
      body: todo.body}
  end
end
