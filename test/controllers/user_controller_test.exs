defmodule TodoApp.UserControllerTest do
  use TodoApp.ConnCase

  import OpenmaizeJWT.Create
  alias TodoApp.User

  @valid_attrs %{username: "Bill", password: "^hEsdg*F899"}
  @invalid_attrs %{}

  @secret String.duplicate("12345678", 8)

  {:ok, user_token} = %{id: 3, username: "Tony"}
                      |> generate_token({0, 86400}, @secret)
  @user_token user_token

  setup %{conn: conn} do
    conn = conn
            |> put_req_header("accept", "application/json")
            |> put_req_header("authorization", "Bearer #{@user_token}")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, user_path(conn, :index)
    assert json_response(conn, 200)["data"] |> length == 3
  end

  test "shows chosen user", %{conn: conn} do
    user = Repo.get(User, 1)
    conn = get conn, user_path(conn, :show, user)
    assert json_response(conn, 200)["data"] ==
      %{"id" => user.id,
      "username" => user.username}
  end

  test "returns nil when id is nonexistent", %{conn: conn} do
    conn = get conn, user_path(conn, :show, 10)
    assert json_response(conn, 200)["data"] == nil
  end

  test "creates and returns user when data is valid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(User, %{username: "Bill"})
  end

  test "does not create user and returns errors when data is invalid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @invalid_attrs
    assert json_response(conn, 422)["errors"]["username"] == ["can't be blank"]
  end

  test "deletes user if user is current_user", %{conn: conn} do
    user = Repo.get(User, 3)
    conn = conn |> delete(user_path(conn, :delete, user))
    assert response(conn, 204)
    refute Repo.get(User, user.id)
  end

  test "does not delete user if user is not current_user", %{conn: conn} do
    user = Repo.get(User, 1)
    conn = conn |> delete(user_path(conn, :delete, user))
    assert response(conn, 403)
    assert Repo.get(User, user.id)
  end
end
