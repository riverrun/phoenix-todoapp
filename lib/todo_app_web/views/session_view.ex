defmodule TodoAppWeb.SessionView do
  use TodoAppWeb, :view

  def render("info.json", %{info: token}) do
    %{access_token: token}
  end
end
