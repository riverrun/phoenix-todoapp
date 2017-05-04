defmodule TodoApp.Jobs.Todo do
  use Ecto.Schema

  schema "jobs_todos" do
    field :title, :string
    field :body, :string
    field :notes, :string
    belongs_to :user, TodoApp.Accounts.User

    timestamps()
  end
end
