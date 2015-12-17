defmodule TodoApp.ChangesetView do
  use TodoApp.Web, :view

  @doc """
  Traverses and translates changeset errors.

  See `Ecto.Changeset.traverse_errors/2` for more details.
  """
  def translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, &translate_error/1)
  end

  def render("error.json", %{changeset: changeset}) do
    %{errors: translate_errors(changeset)}
  end

  def translate_error({msg, opts}) do
      String.replace(msg, "%{count}", to_string(opts[:count]))
  end
  def translate_error(msg), do: msg
end
