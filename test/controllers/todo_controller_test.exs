defmodule TodoApp.TodoControllerTest do
  use TodoApp.ConnCase

  import Openmaize.Token.Create
  alias TodoApp.Todo

  @valid_attrs %{body: "Need to find the meaning of life",
                 notes: "Have to finish by next Wednesday",
                 title: "Search for meaning"}
  @invalid_attrs %{result: "satisfactory"}

  setup do
    {:ok, user_token} = %{id: 1, name: "Gladys", role: "user"}
    |> generate_token({-100, 86400})
    conn = conn()
    |> put_req_header("accept", "application/json")
    |> put_req_header("authorization", "Bearer #{user_token}")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, todo_path(conn, :index)
    assert json_response(conn, 200)["data"] |> length == 2
  end

  test "shows chosen todo if it belongs to current_user", %{conn: conn} do
    todo = Repo.get(Todo, 1)
    conn = get conn, todo_path(conn, :show, todo)
    assert json_response(conn, 200)["data"] == %{"id" => todo.id,
      "user_id" => todo.user_id,
      "title" => todo.title,
      "notes" => todo.notes,
      "body" => todo.body}
  end

  test "returns nil when id is nonexistent", %{conn: conn} do
    conn = get conn, todo_path(conn, :show, 10)
    assert json_response(conn, 200)["data"] == nil
  end

  test "creates and renders todo when data is valid", %{conn: conn} do
    conn = post conn, todo_path(conn, :create), todo: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Todo, @valid_attrs)
  end

  test "does not create todo and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, todo_path(conn, :create), todo: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen todo when data is valid", %{conn: conn} do
    todo = Repo.get(Todo, 1)
    conn = put conn, todo_path(conn, :update, todo), todo: %{notes: "Done"}
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Todo, %{title: "Feed pet"})
  end

  test "does not update chosen todo and renders errors when data is invalid", %{conn: conn} do
    todo = Repo.get(Todo, 2)
    conn = put conn, todo_path(conn, :update, todo), todo: @invalid_attrs
    assert json_response(conn, 200)["data"]["title"] == "Greet wife"
  end

  test "deletes chosen todo", %{conn: conn} do
    todo = Repo.get(Todo, 2)
    conn = delete conn, todo_path(conn, :delete, todo)
    assert response(conn, 204)
    refute Repo.get(Todo, todo.id)
  end
end
