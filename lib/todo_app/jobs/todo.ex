defmodule TodoApp.Jobs.Todo do
  use Ecto.Schema

  schema "jobs_todos" do
    field :title, :string
    field :body, :string
    field :notes, :string
    field :user_id, :id

    timestamps()
  end
end
