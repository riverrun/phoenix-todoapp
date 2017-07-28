defmodule TodoAppWeb.SessionView do
  use TodoAppWeb, :view

  def render("info.json", %{info: message}) do
    %{info: %{detail: message}}
  end
end
