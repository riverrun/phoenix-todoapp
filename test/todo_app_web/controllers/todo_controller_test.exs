defmodule TodoAppWeb.TodoControllerTest do
  use TodoAppWeb.ConnCase

  import TodoAppWeb.AuthCase
  alias TodoApp.Jobs

  @create_attrs %{
    body: "Need to find the meaning of life",
    notes: "Have to finish by next Wednesday",
    title: "Search for meaning"
  }
  @update_attrs %{notes: "Done"}
  @invalid_attrs %{title: "", result: ""}

  def add_todo(user, attrs) do
    {:ok, todo} = Jobs.create_todo(user, attrs)
    todo
  end

  setup %{conn: conn} do
    todo = %{
      body: "Need to feed the pet tiger",
      notes: "Complete before grandma visits",
      title: "Feed pet"
    }

    user = add_user("gladys@mail.com")
    todo = add_todo(user, todo)
    conn = conn |> add_token_conn(user)
    {:ok, %{conn: conn, user: user, todo: todo}}
  end

  test "lists all entries on index", %{conn: conn, user: user} do
    conn = get(conn, user_todo_path(conn, :index, user))
    assert json_response(conn, 200)["data"] |> length == 1
  end

  test "shows chosen todo if it belongs to current_user", %{conn: conn, user: user, todo: todo} do
    conn = get(conn, user_todo_path(conn, :show, user, todo))

    assert json_response(conn, 200)["data"] == %{
             "id" => todo.id,
             "user_id" => todo.user_id,
             "title" => todo.title,
             "notes" => todo.notes,
             "body" => todo.body
           }
  end

  test "returns errors when current_user is nil", %{user: user, todo: todo} do
    conn =
      build_conn()
      |> put_req_header("accept", "application/json")
      |> get(user_todo_path(build_conn(), :show, user, todo))

    assert json_response(conn, 401)["errors"]["detail"] =~ "need to login"
  end

  test "returns errors when todo does not belong to current_user", %{conn: conn} do
    other = add_user("fred@mail.com")
    conn = get(conn, user_todo_path(conn, :show, other, 3))
    assert json_response(conn, 403)["errors"]["detail"] =~ "are not authorized"
  end

  test "returns nil when id is nonexistent", %{conn: conn, user: user} do
    conn = get(conn, user_todo_path(conn, :show, user, 10))
    assert json_response(conn, 200)["data"] == nil
  end

  test "creates and returns todo when data is valid", %{conn: conn, user: user} do
    conn = post(conn, user_todo_path(conn, :create, user), todo: @create_attrs)
    assert json_response(conn, 201)["data"]["id"]
    assert Jobs.get_by(@create_attrs)
  end

  test "does not create todo and returns errors when data is invalid", %{conn: conn, user: user} do
    conn = post(conn, user_todo_path(conn, :create, user), todo: @invalid_attrs)
    assert json_response(conn, 422)["errors"]["body"] == ["can't be blank"]
  end

  test "updates and returns chosen todo when data is valid", %{conn: conn, user: user, todo: todo} do
    conn = put(conn, user_todo_path(conn, :update, user, todo), todo: @update_attrs)
    assert json_response(conn, 200)["data"]["id"]
    assert Jobs.get_by(%{title: "Feed pet"})
  end

  test "does not update chosen todo when data is invalid", %{conn: conn, user: user, todo: todo} do
    conn = put(conn, user_todo_path(conn, :update, user, todo), todo: @invalid_attrs)
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen todo", %{conn: conn, user: user, todo: todo} do
    conn = delete(conn, user_todo_path(conn, :delete, user, todo))
    assert response(conn, 204)
    refute Jobs.get_todo(todo.id)
  end
end
