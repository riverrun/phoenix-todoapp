defmodule TodoApp.TestHelpers do
  use Phoenix.ConnTest

  import OpenmaizeJWT.Create
  alias TodoApp.{Repo, Todo, User}

  def add_user(username) do
    user = %{username: username, email: "#{username}@mail.com",
     password: "mangoes&g0oseberries"}
    %User{}
    |> User.auth_changeset(user)
    |> Repo.insert!
  end

  def add_token_conn(conn, user) do
    Application.put_env(:openmaize_jwt, :signing_key, String.duplicate("12345678", 8))
    {:ok, user_token} = %{id: user.id, username: user.username}
    |> generate_token({0, 86400})
    conn
    |> put_req_header("accept", "application/json")
    |> put_req_header("authorization", "Bearer #{user_token}")
  end

  def add_todo(user, todo) do
    Ecto.build_assoc(user, :todos) |> Todo.changeset(todo) |> Repo.insert!
  end
end
