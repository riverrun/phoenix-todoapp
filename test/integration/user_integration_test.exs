defmodule TodoAppWeb.UserIntegrationTest do
  use TodoApp.DataCase

  import TodoAppWeb.AuthCase
  import TodoAppWeb.IntegrationHelper

  setup do
    user = add_user("ted@mail.com")
    other = add_user("frank@mail.com")
    {:ok, %{user: user, other: other}}
  end

  test "login and use token to access protected resource" do
    %{"access_token" => token} = login_user("ted@mail.com")
    {:ok, response} = token |> authenticated_client() |> Tesla.get("/users")
    %Tesla.Env{body: %{"data" => data}, status: status} = response
    assert length(data) == 2
    assert status == 200
  end

  test "login and view other user's details", %{other: %{id: id}} do
    %{"access_token" => token} = login_user("ted@mail.com")
    {:ok, response} = token |> authenticated_client() |> Tesla.get("/users/#{id}")
    %Tesla.Env{body: %{"data" => data}, status: status} = response
    assert data["id"] == id
    assert status == 200
  end

  test "login fails for incorrect password" do
    %{"errors" => %{"detail" => message}} = login_user("ted@mail.com", "password")
    assert message =~ "need to login"
  end

  test "can delete own user", %{user: %{id: id}} do
    %{"access_token" => token} = login_user("ted@mail.com")
    {:ok, response} = token |> authenticated_client() |> Tesla.delete("/users/#{id}")
    assert %Tesla.Env{body: "", status: 204} = response
  end

  test "cannot delete other user", %{other: %{id: id}} do
    %{"access_token" => token} = login_user("ted@mail.com")
    {:ok, response} = token |> authenticated_client() |> Tesla.delete("/users/#{id}")
    %Tesla.Env{body: %{"errors" => %{"detail" => message}}, status: status} = response
    assert message =~ "are not authorized"
    assert status == 403
  end
end
