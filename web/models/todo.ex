defmodule TodoApp.Todo do
  use TodoApp.Web, :model

  schema "todos" do
    field :title, :string
    field :body, :string
    field :notes, :string
    belongs_to :user, TodoApp.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :body, :notes])
    |> validate_required([:title, :body])
  end
end
