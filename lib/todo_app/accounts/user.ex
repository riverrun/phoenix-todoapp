defmodule TodoApp.Accounts.User do
  use Ecto.Schema

  schema "accounts_users" do
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    has_many :jobs_todos, TodoApp.Jobs.Todo

    timestamps()
  end
end
