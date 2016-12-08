defmodule TodoApp.SessionView do
  use TodoApp.Web, :view

  def render("info.json", %{info: message}) do
    %{info: %{detail: message}}
  end
end
