defmodule TodoApp.Web.SessionView do
  use TodoApp.Web, :view

  def render("info.json", %{info: token}) do
    %{access_token: token}
  end
end
