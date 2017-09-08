defmodule TodoAppWeb.UserIntegrationTest do
  use TodoAppWeb.IntegrationCase

  import TodoAppWeb.AuthCase
  alias WuffWuff.Api

  setup do
    user = add_user("ted@mail.com")
    other = add_user("frank@mail.com")
    {:ok, %{user: user, other: other}}
  end

  def login_user(password \\ "mangoes&g0oseberries") do
    body = %{session: %{email: "ted@mail.com", password: password}}
    Api.post("/sessions", body)
  end

  test "login and use token to access protected resource" do
    {:ok, %{body: %{"access_token" => token}}} = login_user()
    {:ok, %{body: %{"data" => data}}} = Api.get("/users", [{"Authorization", token}])
    assert length(data) == 2
  end

  test "login and view other user's details", %{other: %{id: id}} do
    {:ok, %{body: %{"access_token" => token}}} = login_user()
    {:ok, %{body: %{"data" => data}}} = Api.get("/users/#{id}", [{"Authorization", token}])
    assert data["id"] == id
  end

  test "login fails for incorrect password" do
    {:ok, %{body: %{"errors" => %{"detail" => message}}}} = login_user("password")
    assert message =~ "need to login"
  end

  test "can delete own user", %{user: %{id: id}} do
    {:ok, %{body: %{"access_token" => token}}} = login_user()
    {:ok, response} = Api.delete("/users/#{id}", [{"Authorization", token}])
    assert response.body == ""
    assert response.status_code == 204
  end

  test "cannot delete other user", %{other: %{id: id}} do
    {:ok, %{body: %{"access_token" => token}}} = login_user()
    {:ok, %{body: %{"errors" => %{"detail" => message}}}} =
      Api.delete("/users/#{id}", [{"Authorization", token}])
    assert message =~ "are not authorized"
  end

end
