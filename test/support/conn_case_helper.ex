defmodule ConnCase.Helper do

  import Comeonin.Bcrypt
  import Ecto.Model
  alias TodoApp.Repo
  alias TodoApp.User

  @users [
    %{id: 1, name: "Gladys", role: "user", password_hash: hashpwsalt("mangoes")},
    %{id: 2, name: "Fred", role: "user", password_hash: hashpwsalt("mangoes")},
    %{id: 3, name: "Tony", role: "user", password_hash: hashpwsalt("mangoes")}
  ]
  @todos [
    %{id: 1, title: "Feed pet", notes: "Attempted, but not finished",
      body: "Need to feed the pet tiger before grandma visits"},
    %{id: 2, title: "Greet wife", notes: "Done",
      body: "Need to say hello to the wife at least once a week"},
    %{id: 3, title: "Start revolution", notes: "Delayed because of bad back",
      body: "Need to overthrow the current government"}
  ]

  def add_users do
    for user <- @users do
      %User{} |> Map.merge(user) |> Repo.insert!
    end
  end

  def add_todos(user_1, user_2) do
    [todo_1, todo_2, todo_3] = @todos
    add_todo(user_1, todo_1)
    add_todo(user_1, todo_2)
    add_todo(user_2, todo_3)
  end

  def add_todo(user, todo) do
    user |> build(:todos, todo) |> Repo.insert!
  end

end
