defmodule TodoApp.TodoControllerTest do
  use TodoApp.ConnCase

  import OpenmaizeJWT.Create
  alias TodoApp.Todo
  alias TodoApp.User

  @valid_attrs %{body: "Need to find the meaning of life",
                 notes: "Have to finish by next Wednesday",
                 title: "Search for meaning"}
  @invalid_attrs %{title: "Whatever", result: "satisfactory"}

  @secret String.duplicate("12345678", 8)

  {:ok, user_token} = %{id: 1, username: "Gladys"}
                      |> generate_token({0, 86400}, @secret)
  @user_token user_token

  setup %{conn: conn} do
    conn = conn
            |> put_req_header("accept", "application/json")
            |> put_req_header("authorization", "Bearer #{@user_token}")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, user_todo_path(conn, :index, Repo.get(User, 1))
    assert json_response(conn, 200)["data"] |> length == 2
  end

  test "shows chosen todo if it belongs to current_user", %{conn: conn} do
    todo = Repo.get(Todo, 1)
    conn = get conn, user_todo_path(conn, :show, Repo.get(User, 1), todo)
    assert json_response(conn, 200)["data"] == %{"id" => todo.id,
      "user_id" => todo.user_id,
      "title" => todo.title,
      "notes" => todo.notes,
      "body" => todo.body}
  end

  test "returns errors when current_user is nil" do
    todo = Repo.get(Todo, 1)
    conn = build_conn()
            |> put_req_header("accept", "application/json")
            |> get(user_todo_path(build_conn(), :show, Repo.get(User, 1), todo))
    assert json_response(conn, 200)["errors"]["detail"] =~ "have to login to access this page"
  end

  test "returns errors when todo does not belong to current_user", %{conn: conn} do
    conn = get conn, user_todo_path(conn, :show, Repo.get(User, 2), 3)
    assert json_response(conn, 200)["errors"]["detail"] =~ "have to login to access this page"
  end

  test "returns nil when id is nonexistent", %{conn: conn} do
    conn = get conn, user_todo_path(conn, :show, Repo.get(User, 1), 10)
    assert json_response(conn, 200)["data"] == nil
  end

  test "creates and returns todo when data is valid", %{conn: conn} do
    conn = post conn, user_todo_path(conn, :create, Repo.get(User, 1)), todo: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Todo, @valid_attrs)
  end

  test "does not create todo and returns errors when data is invalid", %{conn: conn} do
    conn = post conn, user_todo_path(conn, :create, Repo.get(User, 1)), todo: @invalid_attrs
    assert json_response(conn, 422)["errors"]["body"] == ["can't be blank"]
  end

  test "updates and returns chosen todo when data is valid", %{conn: conn} do
    todo = Repo.get(Todo, 1)
    conn = put conn, user_todo_path(conn, :update, Repo.get(User, 1), todo), todo: %{notes: "Done"}
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Todo, %{title: "Feed pet"})
  end

  test "does not update chosen todo when data is invalid", %{conn: conn} do
    todo = Repo.get(Todo, 2)
    conn = put conn, user_todo_path(conn, :update, Repo.get(User, 1), todo), todo: @invalid_attrs
    refute json_response(conn, 200)["data"]["result"]
    assert json_response(conn, 200)["data"]["title"] == "Whatever"
  end

  test "deletes chosen todo", %{conn: conn} do
    todo = Repo.get(Todo, 2)
    conn = delete conn, user_todo_path(conn, :delete, Repo.get(User, 1), todo)
    assert response(conn, 204)
    refute Repo.get(Todo, todo.id)
  end
end
