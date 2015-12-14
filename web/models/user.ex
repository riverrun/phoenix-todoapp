defmodule TodoApp.User do
  use TodoApp.Web, :model

  schema "users" do
    field :name, :string
    field :role, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    has_many :todos, TodoApp.Todo

    timestamps
  end

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, ~w(name role), [])
    |> validate_length(:name, min: 1, max: 100)
    |> unique_constraint(:name)
  end

  def auth_changeset(model, params) do
    model
    |> changeset(params)
    |> cast(params, ~w(password), [])
    |> validate_length(:password, min: 8, max: 80)
    |> put_pass_hash()
  end

  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(password))
      _ ->
        changeset
    end
  end
end
