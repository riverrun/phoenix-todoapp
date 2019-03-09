# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#

users = [
  %{email: "jane.doe@example.com", password: "password"},
  %{email: "john.smith@example.org", password: "password"}
]

for user <- users do
  {:ok, _} = TodoApp.Accounts.create_user(user)
end
