defmodule TodoAppWeb.SessionControllerTest do
  use TodoAppWeb.ConnCase

  import TodoAppWeb.AuthCase

  @create_attrs %{email: "robin@mail.com", password: "mangoes&g0oseberries"}
  @invalid_attrs %{email: "robin@mail.com", password: "maaaangoes&g00zeberries"}

  setup %{conn: conn} do
    user = add_user("robin@mail.com")
    {:ok, %{conn: conn, user: user}}
  end

  test "login succeeds", %{conn: conn} do
    conn = post conn, session_path(conn, :create), session: @create_attrs
    assert json_response(conn, 200)["access_token"]
  end

  test "login fails", %{conn: conn} do
    conn = post conn, session_path(conn, :create), session: @invalid_attrs
    assert json_response(conn, 401)["errors"]["detail"] =~ "need to login"
  end
end
