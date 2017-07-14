defmodule TodoApp.Web.SessionController do
  use TodoApp.Web, :controller

  import TodoApp.Web.Authorize

  def create(conn, %{"session" => session_params}) do
    case Phauxth.Login.verify(session_params, TodoApp.Accounts) do
      {:ok, user} ->
        token = Phoenix.Token.sign(TodoApp.Web.Endpoint, "user auth", user.id)
        render(conn, TodoApp.Web.SessionView, "info.json", %{info: token})
      {:error, _message} -> error(conn, :unauthorized, 401)
    end
  end
end
