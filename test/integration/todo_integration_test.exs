defmodule TodoAppWeb.TodoIntegrationTest do
  use TodoApp.DataCase

  import TodoAppWeb.AuthCase
  import TodoAppWeb.IntegrationHelper
  alias TodoApp.Jobs

  @todo_attrs %{
    body: "Need to find the meaning of life",
    notes: "Have to finish by next Wednesday",
    title: "Search for meaning"
  }

  setup do
    user = add_user("ted@mail.com")
    other = add_user("frank@mail.com")
    %{"access_token" => token} = login_user("ted@mail.com")
    {:ok, %{user: user, other: other, token: token}}
  end

  def add_todo(user, attrs) do
    {:ok, todo} = Jobs.create_todo(user, attrs)
    todo
  end

  test "can create todo for self", %{user: %{id: id}, token: token} do
    {:ok, response} =
      token |> authenticated_client() |> Tesla.post("/users/#{id}/todos", %{todo: @todo_attrs})

    %Tesla.Env{body: %{"data" => data}} = response
    assert data["body"] =~ "meaning of life"
    assert data["notes"] =~ "finish by next Wednesday"
  end

  test "can view own todo", %{user: user, token: token} do
    todo = add_todo(user, @todo_attrs)

    {:ok, response} =
      token |> authenticated_client() |> Tesla.get("/users/#{user.id}/todos/#{todo.id}")

    %Tesla.Env{body: %{"data" => data}} = response
    assert data["body"] =~ "meaning of life"
    assert data["notes"] =~ "finish by next Wednesday"
  end

  test "cannot view other todo", %{other: other, token: token} do
    todo = add_todo(other, @todo_attrs)

    {:ok, response} =
      token |> authenticated_client() |> Tesla.get("/users/#{other.id}/todos/#{todo.id}")

    %Tesla.Env{body: %{"errors" => %{"detail" => message}}, status: status} = response
    assert message =~ "not authorized to view this resource"
    assert status == 403
  end
end
