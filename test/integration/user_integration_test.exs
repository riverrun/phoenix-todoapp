defmodule TodoAppWeb.UserIntegrationTest do
  use TodoAppWeb.IntegrationCase

  import WuffWuff.Api
  import TodoAppWeb.AuthCase

  setup do
    user = add_user("ted@mail.com")
    other = add_user("frank@mail.com")
    {:ok, %{user: user, other: other}}
  end

  test "login and use token to access protected resource" do
    %{"access_token" => token} = login_user(:email, "ted@mail.com")
    %{"data" => data} = get!("/users", ~a(#{token})).body
    assert length(data) == 2
  end

  test "login and view other user's details", %{other: %{id: id}} do
    %{"access_token" => token} = login_user(:email, "ted@mail.com")
    %{"data" => data} = get!("/users/#{id}", ~a(#{token})).body
    assert data["id"] == id
  end

  test "login fails for incorrect password" do
    %{"errors" => %{"detail" => message}} = login_user(:email, "ted@mail.com", "password")
    assert message =~ "need to login"
  end

  test "can delete own user", %{user: %{id: id}} do
    %{"access_token" => token} = login_user(:email, "ted@mail.com")
    response = delete!("/users/#{id}", ~a(#{token}))
    assert response.body == ""
    assert response.status_code == 204
  end

  test "cannot delete other user", %{other: %{id: id}} do
    %{"access_token" => token} = login_user(:email, "ted@mail.com")
    %{"errors" => %{"detail" => message}} = delete!("/users/#{id}", ~a(#{token})).body
    assert message =~ "are not authorized"
  end
end
