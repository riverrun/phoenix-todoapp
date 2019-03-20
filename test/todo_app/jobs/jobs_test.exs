defmodule TodoApp.JobsTest do
  use TodoApp.DataCase

  import TodoAppWeb.AuthTestHelpers

  alias TodoApp.{Jobs, Jobs.Todo}

  @create_attrs %{
    body: "Need to find the meaning of life",
    notes: "Have to finish by next Wednesday",
    title: "Search for meaning"
  }
  @update_attrs %{notes: "Done"}
  @invalid_attrs %{body: nil, title: nil}

  describe "todos" do
    setup [:create_user, :create_todo]

    test "list_todos returns all a user's todos", %{todo: todo, user: user} do
      assert Jobs.list_todos(user) == [todo]
    end

    test "get_todo returns the todo with given id", %{todo: todo} do
      assert Jobs.get_todo(todo.id) == todo
    end

    test "get_user_todo returns the todo with given id for correct user", %{
      todo: todo,
      user: user
    } do
      assert Jobs.get_user_todo(user, todo.id) == todo
      other = add_user("igor@mail.com")
      refute Jobs.get_user_todo(other, todo.id)
    end

    test "create_todo with valid data creates a todo", %{user: user} do
      assert {:ok, %Todo{} = todo} = Jobs.create_todo(user, @create_attrs)
      assert todo.body == "Need to find the meaning of life"
      assert todo.title == "Search for meaning"
      assert todo.notes == "Have to finish by next Wednesday"
    end

    test "create_todo with invalid data returns error changeset", %{user: user} do
      assert {:error, %Ecto.Changeset{}} = Jobs.create_todo(user, @invalid_attrs)
    end

    test "update_todo with valid data updates the todo", %{todo: todo} do
      assert {:ok, todo} = Jobs.update_todo(todo, @update_attrs)
      assert %Todo{} = todo
      assert todo.notes == "Done"
    end

    test "update_todo with invalid data returns error changeset", %{todo: todo} do
      assert {:error, %Ecto.Changeset{}} = Jobs.update_todo(todo, @invalid_attrs)
      assert todo == Jobs.get_todo(todo.id)
    end

    test "delete_todo deletes the todo", %{todo: todo} do
      assert {:ok, %Todo{}} = Jobs.delete_todo(todo)
      refute Jobs.get_todo(todo.id)
    end

    test "change_todo returns a todo changeset", %{todo: todo} do
      assert %Ecto.Changeset{} = Jobs.change_todo(todo)
    end
  end

  defp create_user(_) do
    user = add_user("froderick@mail.com")
    {:ok, %{user: user}}
  end

  defp create_todo(%{user: user}) do
    {:ok, todo} = Jobs.create_todo(user, @create_attrs)
    {:ok, %{todo: todo, user: user}}
  end
end
