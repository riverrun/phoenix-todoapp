defmodule TodoApp.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias TodoApp.Accounts.User

  schema "users" do
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    has_many :todos, TodoApp.Jobs.Todo

    timestamps()
  end

  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :password])
    |> validate_required([:email])
    |> unique_constraint(:email)
  end

  def create_changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
    |> unique_constraint(:email)
    |> put_pass_hash()
  end

  def put_pass_hash(%Ecto.Changeset{valid?: true, changes:
      %{password: password}} = changeset) do
    change(changeset, Comeonin.Argon2.add_hash(password))
  end
  def put_pass_hash(changeset), do: changeset
end
