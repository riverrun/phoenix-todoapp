defmodule TodoApp.User do
  use TodoApp.Web, :model

  alias TodoApp.OpenmaizeEcto

  schema "users" do
    field :username, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    has_many :todos, TodoApp.Todo

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:username])
    |> validate_required([:username])
    |> unique_constraint(:username)
  end

  def auth_changeset(model, params) do
    model
    |> changeset(params)
    |> OpenmaizeEcto.add_password_hash(params)
  end
end
