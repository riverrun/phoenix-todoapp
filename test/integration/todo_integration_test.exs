defmodule TodoAppWeb.TodoIntegrationTest do
  use TodoAppWeb.IntegrationCase

  import WuffWuff.Api
  import TodoAppWeb.AuthCase
  alias TodoApp.Jobs

  @todo_attrs %{body: "Need to find the meaning of life",
    notes: "Have to finish by next Wednesday",
    title: "Search for meaning"}

  setup do
    user = add_user("ted@mail.com")
    other = add_user("frank@mail.com")
    %{"access_token" => token} = login_user(:email, "ted@mail.com")
    {:ok, %{user: user, other: other, token: token}}
  end

  def add_todo(user, attrs) do
    {:ok, todo} = Jobs.create_todo(user, attrs)
    todo
  end

  test "can create todo for self", %{user: %{id: id}, token: token} do
    %{"data" => data} = post!("/users/#{id}/todos", %{todo: @todo_attrs}, ~a(#{token})).body
    assert data["body"] =~ "meaning of life"
    assert data["notes"] =~ "finish by next Wednesday"
  end

  test "can view own todo", %{user: user, token: token} do
    todo = add_todo(user, @todo_attrs)
    %{"data" => data} = get!("/users/#{user.id}/todos/#{todo.id}", ~a(#{token})).body
    assert data["body"] =~ "meaning of life"
    assert data["notes"] =~ "finish by next Wednesday"
  end

  test "cannot view other todo", %{other: other, token: token} do
    todo = add_todo(other, @todo_attrs)
    %{"errors" => %{"detail" => message}} = get!("/users/#{other.id}/todos/#{todo.id}", ~a(#{token})).body
    assert message =~ "not authorized to view this resource"
  end

end
