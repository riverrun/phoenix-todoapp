defmodule TodoApp.TodoControllerTest do
  use TodoApp.ConnCase

  import Openmaize.Token.Create
  alias TodoApp.Todo
  alias TodoApp.User

  @valid_attrs %{body: "Need to find the meaning of life",
                 notes: "Have to finish by next Wednesday",
                 title: "Search for meaning"}
  @invalid_attrs %{title: "Whatever", result: "satisfactory"}

  {:ok, user_token} = %{id: 1, name: "Gladys", role: "user"}
                      |> generate_token(:name, {0, 86400})
  @user_token user_token
  @user Repo.get(User, 1)

  setup do
    conn = conn()
    |> put_req_header("accept", "application/json")
    |> put_req_header("authorization", "Bearer #{@user_token}")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, user_todo_path(conn, :index, @user)
    assert json_response(conn, 200)["data"] |> length == 2
  end

  test "shows chosen todo if it belongs to current_user", %{conn: conn} do
    todo = Repo.get(Todo, 1)
    conn = get conn, user_todo_path(conn, :show, @user, todo)
    assert json_response(conn, 200)["data"] == %{"id" => todo.id,
      "user_id" => todo.user_id,
      "title" => todo.title,
      "notes" => todo.notes,
      "body" => todo.body}
  end

  test "returns errors when current_user is nil" do
    todo = Repo.get(Todo, 1)
    conn = conn()
    |> put_req_header("accept", "application/json")
    |> get(user_todo_path(conn, :show, @user, todo))
    assert json_response(conn, 200)["errors"]["detail"] =~ "have to login"
  end

  test "returns errors when todo does not belong to current_user", %{conn: conn} do
    conn = get conn, user_todo_path(conn, :show, Repo.get(User, 2), 3)
    assert json_response(conn, 200)["errors"]["detail"] =~ "not allowed to access"
  end

  test "returns nil when id is nonexistent", %{conn: conn} do
    conn = get conn, user_todo_path(conn, :show, @user, 10)
    assert json_response(conn, 200)["data"] == nil
  end

  test "creates and returns todo when data is valid", %{conn: conn} do
    conn = post conn, user_todo_path(conn, :create, @user), todo: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Todo, @valid_attrs)
  end

  test "does not create todo and returns errors when data is invalid", %{conn: conn} do
    conn = post conn, user_todo_path(conn, :create, @user), todo: @invalid_attrs
    assert json_response(conn, 422)["errors"]["body"] == ["can't be blank"]
  end

  test "updates and returns chosen todo when data is valid", %{conn: conn} do
    todo = Repo.get(Todo, 1)
    conn = put conn, user_todo_path(conn, :update, @user, todo), todo: %{notes: "Done"}
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Todo, %{title: "Feed pet"})
  end

  test "does not update chosen todo when data is invalid", %{conn: conn} do
    todo = Repo.get(Todo, 2)
    conn = put conn, user_todo_path(conn, :update, @user, todo), todo: @invalid_attrs
    refute json_response(conn, 200)["data"]["result"]
    assert json_response(conn, 200)["data"]["title"] == "Whatever"
  end

  test "deletes chosen todo", %{conn: conn} do
    todo = Repo.get(Todo, 2)
    conn = delete conn, user_todo_path(conn, :delete, @user, todo)
    assert response(conn, 204)
    refute Repo.get(Todo, todo.id)
  end
end
