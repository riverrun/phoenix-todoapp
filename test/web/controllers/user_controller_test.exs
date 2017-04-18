defmodule TodoApp.Web.UserControllerTest do
  use TodoApp.Web.ConnCase

  import TodoApp.Web.AuthCase
  alias TodoApp.Accounts

  @create_attrs %{email: "bill@mail.com", password: "^hEsdg*F899"}
  @update_attrs %{email: "billy@mail.com"}
  @invalid_attrs %{email: "", password: ""}

  setup %{conn: conn} = config do
    if email = config[:login] do
      user = add_user(email)
      other = add_user("tony@mail.com")

      conn = conn |> add_token_conn(user)
      {:ok, %{conn: conn, user: user, other: other}}
    else
      {:ok, %{conn: conn}}
    end
  end

  @tag login: "reg"
  test "renders /users for authorized user", %{conn: conn} do
    conn = get conn, user_path(conn, :index)
    assert json_response(conn, 200)
  end

  test "renders /users error for unauthorized user", %{conn: conn}  do
    conn = get conn, user_path(conn, :index)
    assert json_response(conn, 401)
  end

  test "creates resource when data is valid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @create_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Accounts.get_by(%{email: "bill@mail.com"})
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  @tag login: "reg"
  test "renders /users/:id", %{conn: conn, user: user} do
    conn = get conn, user_path(conn, :show, user)
    assert json_response(conn, 200)["data"] == %{"id" => user.id, "email" => "reg"}
  end

  @tag login: "reg"
  test "updates /users/:id with valid data", %{conn: conn, user: user} do
    conn = put conn, user_path(conn, :update, user), user: @update_attrs
    assert json_response(conn, 200)["data"]["id"] == user.id
    new_user = Accounts.get_user(user.id)
    assert new_user.email == "billy@mail.com"
  end

  @tag login: "reg"
  test "does not update /users/:id with invalid data", %{conn: conn, user: user} do
    conn = put conn, user_path(conn, :update, user), user: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  @tag login: "reg"
  test "deletes current user", %{conn: conn, user: user} do
    Accounts.get_user(user.id)
    conn = delete conn, user_path(conn, :delete, user)
    assert response(conn, 204)
    refute Accounts.get_user(user.id)
  end

  @tag login: "reg"
  test "cannot delete other user", %{conn: conn, other: other} do
    conn = delete conn, user_path(conn, :delete, other)
    assert json_response(conn, 403)["errors"]["detail"] =~ "not authorized"
    assert Accounts.get_user(other.id)
  end
end
