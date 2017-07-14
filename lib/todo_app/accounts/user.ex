defmodule TodoApp.Accounts.User do
  use Ecto.Schema

  schema "users" do
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    has_many :todos, TodoApp.Jobs.Todo

    timestamps()
  end
end
