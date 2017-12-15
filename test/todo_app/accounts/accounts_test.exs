defmodule TodoApp.AccountsTest do
  use TodoApp.DataCase

  alias TodoApp.Accounts
  alias TodoApp.Accounts.User

  @create_attrs %{email: "fred@example.com", password: "reallyHard2gue$$"}
  @update_attrs %{email: "frederick@example.com"}
  @invalid_attrs %{email: nil}

  describe "users" do
    setup [:create_user]

    test "list_users returns all users", %{user: user} do
      assert Accounts.list_users() == [user]
    end

    test "get returns the user with given id", %{user: user} do
      assert Accounts.get(user.id) == user
    end

    test "create_user with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@create_attrs)
      assert user.email == "fred@example.com"
    end

    test "create_user with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user with valid data updates the user", %{user: user} do
      assert {:ok, user} = Accounts.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.email == "frederick@example.com"
    end

    test "update_user with invalid data returns error changeset", %{user: user} do
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get(user.id)
    end

    test "delete_user deletes the user", %{user: user} do
      assert {:ok, %User{}} = Accounts.delete_user(user)
      refute Accounts.get(user.id)
    end

    test "change_user returns a user changeset", %{user: user} do
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end

  defp create_user(_) do
    attrs = %{email: "brian@example.com", password: "reallyHard2gue$$"}
    {:ok, user} = Accounts.create_user(attrs)
    {:ok, %{user: user}}
  end
end
