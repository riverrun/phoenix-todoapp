ExUnit.start

Mix.Task.run "ecto.drop", ["--quiet"]
Mix.Task.run "ecto.create", ["--quiet"]
Mix.Task.run "ecto.migrate", ["--quiet"]

[user_1, user_2, _] = ConnCase.Helper.add_users()
ConnCase.Helper.add_todos(user_1, user_2)

Ecto.Adapters.SQL.begin_test_transaction(TodoApp.Repo)
