Code.require_file "support/integration_helper.exs", __DIR__

defmodule TodoAppWeb.UserIntegrationTest do
  use TodoAppWeb.IntegrationCase

  import TodoAppWeb.AuthCase
  import TodoAppWeb.IntegrationHelper

  setup do
    user = add_user("ted@mail.com")
    other = add_user("frank@mail.com")
    {:ok, %{user: user, other: other}}
  end

  test "login and use token to access protected resource" do
    %{"access_token" => token} = login_user("ted@mail.com")
    %{"data" => data} = auth_get("/users", token).body
    assert length(data) == 2
  end

  test "login and view other user's details", %{other: %{id: id}} do
    %{"access_token" => token} = login_user("ted@mail.com")
    %{"data" => data} = auth_get("/users/#{id}", token).body
    assert data["id"] == id
  end

  test "login fails for incorrect password" do
    %{"errors" => %{"detail" => message}} = login_user("ted@mail.com", "password")
    assert message =~ "need to login"
  end

  test "can delete own user", %{user: %{id: id}} do
    %{"access_token" => token} = login_user("ted@mail.com")
    response = auth_del("/users/#{id}", token)
    assert response.body == ""
    assert response.status_code == 204
  end

  test "cannot delete other user", %{other: %{id: id}} do
    %{"access_token" => token} = login_user("ted@mail.com")
    %{"errors" => %{"detail" => message}} = auth_del("/users/#{id}", token).body
    assert message =~ "are not authorized"
  end

end
