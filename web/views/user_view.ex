defmodule TodoApp.UserView do
  use TodoApp.Web, :view

  def render("index.json", %{users: users}) do
    %{data: render_many(users, TodoApp.UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, TodoApp.UserView, "user.json")}
  end

  def render("info.json", %{info: message}) do
    %{info: %{detail: message}}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      username: user.username}
  end
end
