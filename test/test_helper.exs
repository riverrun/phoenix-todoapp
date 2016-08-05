ExUnit.start

#Ecto.Adapters.SQL.Sandbox.mode(TodoApp.Repo, :manual)

#[user_1, user_2, _] = ConnCase.Helper.add_users()
#ConnCase.Helper.add_todos(user_1, user_2)
Ecto.Adapters.SQL.Sandbox.mode(TodoApp.Repo, {:shared, self()})
