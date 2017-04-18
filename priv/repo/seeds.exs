# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     TodoApp.Repo.insert!(%TodoApp.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias TodoApp.{Accounts, Jobs}

data = [
  %{user: %{email: "ted@mail.com", password: "password"},
    todos: [%{title: "Feed the pet tiger",
              body: "Need to feed the pet tiger before grandma comes"},
            %{title: "Greet the wife",
              body: "Find some time this month to say hello to the wife"}]},
  %{user: %{email: "franny@mail.com", password: "password"},
    todos: [%{title: "Start the revolution",
              body: "Get the world revolution started before next Wednesday"},
            %{title: "Find meaning of life",
              body: "Find meaning of life"}]},
  %{user: %{email: "eddybaby@mail.com", password: "password"},
    todos: [%{title: "Arrrrrrrrrr",
              body: "Shiver me timbers, I need to find me a comely wench!"},
            %{title: "Foooooood!",
              body: "On the lookout for a gert lush treat"}]}
]

for item <- data do
  {:ok, user} = Accounts.create_user(item[:user])
  for todo <- item[:todos] do
    Jobs.create_todo(user, todo)
  end
end
