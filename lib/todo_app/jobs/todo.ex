defmodule TodoApp.Jobs.Todo do
  use Ecto.Schema

  import Ecto.Changeset

  alias TodoApp.{Accounts.User, Jobs.Todo}

  @type t :: %__MODULE__{
          id: integer,
          title: String.t(),
          body: String.t(),
          notes: String.t(),
          user_id: integer,
          user: %Ecto.Association.NotLoaded{} | User.t(),
          inserted_at: DateTime.t(),
          updated_at: DateTime.t()
        }

  schema "todos" do
    field :title, :string
    field :body, :string
    field :notes, :string
    belongs_to :user, TodoApp.Accounts.User

    timestamps()
  end

  def todo_changeset(%Todo{} = todo, attrs) do
    todo
    |> cast(attrs, [:title, :body, :notes])
    |> validate_required([:title, :body])
  end
end
