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
    Api.post!("/sessions", body).body
  end

  test "login and use token to access protected resource" do
    %{"access_token" => token} = login_user()
    %{"data" => data} = Api.get!("/users", Api.key(token)).body
    assert length(data) == 2
  end

  test "login and view other user's details", %{other: %{id: id}} do
    %{"access_token" => token} = login_user()
    %{"data" => data} = Api.get!("/users/#{id}", Api.key(token)).body
    assert data["id"] == id
  end

  test "login fails for incorrect password" do
    %{"errors" => %{"detail" => message}} = login_user("password")
    assert message =~ "need to login"
  end

  test "can delete own user", %{user: %{id: id}} do
    %{"access_token" => token} = login_user()
    response = Api.delete!("/users/#{id}", Api.key(token))
    assert response.body == ""
    assert response.status_code == 204
  end

  test "cannot delete other user", %{other: %{id: id}} do
    %{"access_token" => token} = login_user()
    %{"errors" => %{"detail" => message}} = Api.delete!("/users/#{id}", Api.key(token)).body
    assert message =~ "are not authorized"
  end

end
