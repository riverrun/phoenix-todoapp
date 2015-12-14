defmodule TodoApp.ChangesetView do
  use TodoApp.Web, :view

  def render("error.json", %{changeset: changeset}) do
    %{errors: changeset}
  end
end
