defmodule TodoApp.Jobs.Todo do
  use Ecto.Schema

  import Ecto.Changeset

  alias TodoApp.Jobs.Todo

  schema "todos" do
    field(:title, :string)
    field(:body, :string)
    field(:notes, :string)
    belongs_to(:user, TodoApp.Accounts.User)

    timestamps()
  end

  def todo_changeset(%Todo{} = todo, attrs) do
    todo
    |> cast(attrs, [:title, :body, :notes])
    |> validate_required([:title, :body])
  end
end
