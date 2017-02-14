defmodule TodoApp.User do
  use TodoApp.Web, :model

  alias Openmaize.Database, as: DB

  schema "users" do
    field :email, :string
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
    |> cast(params, [:username, :email])
    |> validate_required([:username, :email])
    |> unique_constraint(:email)
  end

  def auth_changeset(struct, params) do
    struct
    |> changeset(params)
    |> DB.add_password_hash(params)
  end
end
