defmodule TodoApp.TestHelpers do
  use Phoenix.ConnTest

  alias TodoApp.{Repo, Todo, User}

  def add_user(username) do
    user = %{username: username, email: "#{username}@mail.com",
     password: "mangoes&g0oseberries"}
    %User{}
    |> User.auth_changeset(user)
    |> Repo.insert!
  end

  def add_token_conn(conn, user) do
    user_token = Phoenix.Token.sign(TodoApp.Endpoint, "user token", user.id)
    conn
    |> put_req_header("accept", "application/json")
    |> put_req_header("authorization", user_token)
  end

  def add_todo(user, todo) do
    Ecto.build_assoc(user, :todos) |> Todo.changeset(todo) |> Repo.insert!
  end
end
