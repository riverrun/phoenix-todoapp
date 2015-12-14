defmodule TodoApp.Todo do
  use TodoApp.Web, :model

  schema "todos" do
    field :title, :string
    field :notes, :string
    field :body, :string
    belongs_to :user, TodoApp.User

    timestamps
  end

  @required_fields ~w(title body)
  @optional_fields ~w(notes)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> unique_constraint(:title, on: Repo)
  end
end
