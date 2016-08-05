defmodule TodoApp.AuthorizeTest do
  use TodoApp.ConnCase

  import OpenmaizeJWT.Create

  @valid_attrs %{username: "tony", password: "mangoes&g0oseberries"}
  @invalid_attrs %{username: "tony", password: "maaaangoes&g00zeberries"}

  @secret String.duplicate("12345678", 8)

  {:ok, user_token} = %{id: 3, username: "tony"}
                      |> generate_token({0, 1440}, @secret)
  @user_token user_token

  setup %{conn: conn} do
    conn = conn
            |> put_req_header("accept", "application/json")
            |> put_req_header("authorization", "Bearer #{@user_token}")
    {:ok, conn: conn}
  end

  # Test routes protected by the id_check plug
  test "id check succeeds", %{conn: conn} do
    IO.inspect conn
    conn = get conn, "/api/users/3"
    assert response(conn, 200)
  end

  test "id check fails for incorrect id", %{conn: conn} do
    conn = get conn, "/api/users/30"
    assert response(conn, 200) =~ "null"
  end

  test "id check fails for nil user" do
    conn = build_conn() |> get("/api/users/3")
    assert response(conn, 200) =~ "have to login to access this page"
  end

  test "login succeeds" do
    conn = post build_conn(), "/api/login", user: @valid_attrs
    assert response(conn, 200)
  end

  test "login fails" do
    conn = post build_conn(), "/api/login", user: @invalid_attrs
    assert response(conn, 200) =~ "have to login to access this page"
  end

end
