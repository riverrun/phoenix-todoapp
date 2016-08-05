# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     TodoApp.Repo.insert!(%TodoApp.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

users = [
  %{id: 1, username: "Gladys", password: "mangoes&gooseberries"},
  %{id: 2, username: "Fred", password: "mangoes&gooseberries"},
  %{id: 3, username: "Tony", password: "mangoes&gooseberries"}
]
todos = [
  %{id: 1, title: "Feed pet", notes: "Attempted, but not finished",
    body: "Need to feed the pet tiger before grandma visits"},
  %{id: 2, title: "Greet wife", notes: "Done",
    body: "Need to say hello to the wife at least once a week"},
  %{id: 3, title: "Start revolution", notes: "Delayed because of bad back",
    body: "Need to overthrow the current government"}
]

[user_1, user_2, _] = for user <- users do
  %TodoApp.User{} |> TodoApp.User.auth_changeset(user) |> TodoApp.Repo.insert!
end

[todo_1, todo_2, todo_3] = todos
user_1 |> Ecto.build_assoc(:todos) |> TodoApp.Todo.changeset(todo_1) |> TodoApp.Repo.insert!
user_1 |> Ecto.build_assoc(:todos) |> TodoApp.Todo.changeset(todo_2) |> TodoApp.Repo.insert!
user_2 |> Ecto.build_assoc(:todos) |> TodoApp.Todo.changeset(todo_3) |> TodoApp.Repo.insert!
