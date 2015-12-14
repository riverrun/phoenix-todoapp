defmodule TodoApp.UserView do
  use TodoApp.Web, :view

  def render("index.json", %{users: users}) do
    %{data: render_many(users, TodoApp.UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, TodoApp.UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      name: user.name,
      role: user.role}
  end
end
