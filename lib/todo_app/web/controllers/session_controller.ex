defmodule TodoApp.Web.SessionController do
  use TodoApp.Web, :controller

  import TodoApp.Web.Authorize

  plug Phauxth.Login when action in [:create]

  def create(%Plug.Conn{private: %{phauxth_error: _message}} = conn, _params) do
    auth_error(conn, :unauthorized, 401)
  end
  def create(%Plug.Conn{private: %{phauxth_user: user}} = conn, _params) do
    token = Phoenix.Token.sign(TodoApp.Web.Endpoint, "user auth", user.id)
    render(conn, TodoApp.Web.SessionView, "info.json", %{info: token})
  end
end
