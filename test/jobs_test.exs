defmodule TodoApp.JobsTest do
  use TodoApp.DataCase

  import TodoApp.Web.AuthCase
  alias TodoApp.Jobs
  alias TodoApp.Jobs.Todo

  @create_attrs %{body: "Need to find the meaning of life",
                 notes: "Have to finish by next Wednesday",
                 title: "Search for meaning"}
  @update_attrs %{notes: "Done"}
  @invalid_attrs %{body: nil, title: nil}

  setup do
    user = add_user("froderick@mail.com")
    {:ok, todo} = Jobs.create_todo(user, @create_attrs)
    {:ok, %{todo: todo, user: user}}
  end

  test "list_todos/1 returns all todos", %{todo: todo} do
    assert Jobs.list_todos() == [todo]
  end

  test "get_todo returns the todo with given id", %{todo: todo} do
    assert Jobs.get_todo(todo.id) == todo
  end

  test "create_todo/1 with valid data creates a todo", %{user: user} do
    assert {:ok, %Todo{} = todo} = Jobs.create_todo(user, @create_attrs)
    assert todo.body == "Need to find the meaning of life"
    assert todo.title == "Search for meaning"
    assert todo.notes == "Have to finish by next Wednesday"
  end

  test "create_todo/1 with invalid data returns error changeset", %{user: user} do
    assert {:error, %Ecto.Changeset{}} = Jobs.create_todo(user, @invalid_attrs)
  end

  test "update_todo/2 with valid data updates the todo", %{todo: todo} do
    assert {:ok, todo} = Jobs.update_todo(todo, @update_attrs)
    assert %Todo{} = todo
    assert todo.notes == "Done"
  end

  test "update_todo/2 with invalid data returns error changeset", %{todo: todo} do
    assert {:error, %Ecto.Changeset{}} = Jobs.update_todo(todo, @invalid_attrs)
    assert todo == Jobs.get_todo(todo.id)
  end

  test "delete_todo/1 deletes the todo", %{todo: todo} do
    assert {:ok, %Todo{}} = Jobs.delete_todo(todo)
    refute Jobs.get_todo(todo.id)
  end

  test "change_todo/1 returns a todo changeset", %{todo: todo} do
    assert %Ecto.Changeset{} = Jobs.change_todo(todo)
  end
end
