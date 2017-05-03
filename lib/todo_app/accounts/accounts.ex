defmodule TodoApp.Accounts do
  @moduledoc """
  The boundary for the Accounts system.
  """

  import Ecto.{Query, Changeset}, warn: false
  alias TodoApp.Repo

  alias TodoApp.Accounts.User

  def list_users do
    Repo.all(User)
  end

  def get_user!(id), do: Repo.get!(User, id)
  def get_user(id), do: Repo.get(User, id)

  def get_by(attrs) do
    Repo.get_by(User, attrs)
  end
  def create_user(attrs) do
    %User{}
    |> create_changeset(attrs)
    |> Repo.insert()
  end

  def update_user(%User{} = user, attrs) do
    user
    |> update_changeset(attrs)
    |> Repo.update()
  end

  def update_password(%User{} = user, attrs) do
    user
    |> update_changeset(attrs)
    |> put_pass_hash()
    |> change(%{reset_token: nil, reset_sent_at: nil})
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def change_user(%User{} = user) do
    user_changeset(user, %{})
  end

  defp user_changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email])
    |> validate_required([:email])
    |> unique_constraint(:email)
  end
  defp create_changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
    |> unique_constraint(:email)
    |> put_pass_hash()
  end

  defp update_changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :password])
    |> validate_required([:email])
    |> unique_constraint(:email)
  end

  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes:
      %{password: password}} = changeset) do
    change(changeset, %{password_hash: Comeonin.Bcrypt.hashpwsalt(password), password: nil})
  end
  defp put_pass_hash(changeset), do: changeset
end
