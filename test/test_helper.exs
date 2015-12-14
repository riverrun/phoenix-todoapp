ExUnit.start

Mix.Task.run "ecto.drop", ["--quiet"]
Mix.Task.run "ecto.create", ["--quiet"]
Mix.Task.run "ecto.migrate", ["--quiet"]

TodoApp.Repo.insert! %TodoApp.User{id: 1,
                                   name: "Gladys",
                                   role: "user",
                                   password_hash: Comeonin.Bcrypt.hashpwsalt("mangoes")}

Ecto.Adapters.SQL.begin_test_transaction(TodoApp.Repo)
