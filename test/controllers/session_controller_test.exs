defmodule TodoApp.SessionControllerTest do
  use TodoApp.ConnCase

  import TodoApp.TestHelpers

  @valid_attrs %{username: "robin", password: "mangoes&g0oseberries"}
  @invalid_attrs %{username: "robin", password: "maaaangoes&g00zeberries"}

  setup %{conn: conn} do
    user = add_user("robin")
    conn = conn |> add_token_conn(user)
    {:ok, %{conn: conn, user: user}}
  end

  test "login succeeds", %{conn: conn} do
    conn = post conn, session_path(conn, :create), session: @valid_attrs
    assert json_response(conn, 200)["info"]["detail"] =~ "have logged in"
  end

  test "login fails", %{conn: conn} do
    conn = post conn, session_path(conn, :create), session: @invalid_attrs
    assert json_response(conn, 401)["errors"]["detail"] =~ "need to login"
  end

  test "logout succeeds", %{conn: conn, user: user} do
    conn = delete conn, session_path(conn, :delete, user)
    assert json_response(conn, 200)["info"]["detail"] =~ "have logged out"
  end

end