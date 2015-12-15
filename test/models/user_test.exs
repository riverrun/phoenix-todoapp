defmodule TodoApp.UserTest do
  use TodoApp.ModelCase

  alias TodoApp.User

  @valid_attrs %{name: "some content", password: "some content", role: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.auth_changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.auth_changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
