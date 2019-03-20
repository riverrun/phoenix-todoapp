defmodule TodoAppWeb.UserControllerTest do
  use TodoAppWeb.ConnCase

  import TodoAppWeb.AuthTestHelpers
  alias TodoApp.Accounts

  @create_attrs %{email: "bill@example.com", password: "hard2guess"}
  @update_attrs %{email: "william@example.com"}
  @invalid_attrs %{email: nil}

  describe "index" do
    test "lists all entries on index", %{conn: conn} do
      user = add_user("reg@example.com")
      conn = conn |> add_token_conn(user)
      conn = get(conn, Routes.user_path(conn, :index))
      assert json_response(conn, 200)
    end

    test "renders /users error for unauthorized user", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :index))
      assert json_response(conn, 401)
    end
  end

  describe "show user resource" do
    setup [:add_user_session]

    test "show chosen user's page", %{conn: conn, user: user} do
      conn = get(conn, Routes.user_path(conn, :show, user))
      assert json_response(conn, 200)["data"] == %{"id" => user.id, "email" => "reg@example.com"}
    end
  end

  describe "create user" do
    test "creates user when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @create_attrs)
      assert json_response(conn, 201)["data"]["id"]
      assert Accounts.get_by(%{"email" => "bill@example.com"})
    end

    test "does not create user and renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "updates user" do
    setup [:add_user_session]

    test "updates chosen user when data is valid", %{conn: conn, user: user} do
      conn = put(conn, Routes.user_path(conn, :update, user), user: @update_attrs)
      assert json_response(conn, 200)["data"]["id"] == user.id
      updated_user = Accounts.get_user(user.id)
      assert updated_user.email == "william@example.com"
    end

    test "does not update chosen user and renders errors when data is invalid", %{
      conn: conn,
      user: user
    } do
      conn = put(conn, Routes.user_path(conn, :update, user), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do
    setup [:add_user_session]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, Routes.user_path(conn, :delete, user))
      assert response(conn, 204)
      refute Accounts.get_user(user.id)
    end

    test "cannot delete other user", %{conn: conn} do
      other = add_user("tony@example.com")
      conn = delete(conn, Routes.user_path(conn, :delete, other))
      assert json_response(conn, 403)["errors"]["detail"] =~ "not authorized"
      assert Accounts.get_user(other.id)
    end
  end

  defp add_user_session(%{conn: conn}) do
    user = add_user("reg@example.com")
    conn = conn |> add_token_conn(user)
    {:ok, %{conn: conn, user: user}}
  end
end
