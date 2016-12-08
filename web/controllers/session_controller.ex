defmodule TodoApp.SessionController do
  use TodoApp.Web, :controller

  import OpenmaizeJWT.Plug

  plug Openmaize.Login when action in [:create]
  #plug Openmaize.Login, [unique_id: :email] when action in [:create]

  def create(%Plug.Conn{private: %{openmaize_error: _message}} = conn, _params) do
    put_status(conn, :unauthorized)
    |> render(TodoApp.AuthView, "401.json", [])
  end
  def create(%Plug.Conn{private: %{openmaize_user: user}} = conn, _params) do
    add_token(conn, user, :username)
    |> render(TodoApp.SessionView, "info.json", %{info: "You have logged in"})
  end

  def delete(conn, _params) do
    logout_user(conn)
    |> render(TodoApp.SessionView, "info.json", %{info: "You have logged out"})
  end
end
