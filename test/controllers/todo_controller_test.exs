defmodule TodoApp.TodoControllerTest do
  use TodoApp.ConnCase

  alias TodoApp.Todo
  alias TodoApp.User
  @valid_attrs %{body: "some content", notes: "some content", title: "some content"}
  @invalid_attrs %{}

  setup do
    conn = conn()
    |> put_req_header("accept", "application/json")
    |> assign(:current_user, %{id: 1, name: "Gladys", role: "user"})
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, todo_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    todo = Repo.insert! %Todo{}
    conn = get conn, todo_path(conn, :show, todo)
    assert json_response(conn, 200)["data"] == %{"id" => todo.id,
      "user_id" => todo.user_id,
      "title" => todo.title,
      "notes" => todo.notes,
      "body" => todo.body}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, todo_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, todo_path(conn, :create), todo: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Todo, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, todo_path(conn, :create), todo: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    todo = Repo.insert! %Todo{}
    conn = put conn, todo_path(conn, :update, todo), todo: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Todo, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    todo = Repo.insert! %Todo{}
    conn = put conn, todo_path(conn, :update, todo), todo: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    todo = Repo.insert! %Todo{}
    conn = delete conn, todo_path(conn, :delete, todo)
    assert response(conn, 204)
    refute Repo.get(Todo, todo.id)
  end
end
