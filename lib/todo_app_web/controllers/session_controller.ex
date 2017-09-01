defmodule TodoAppWeb.SessionController do
  use TodoAppWeb, :controller

  import TodoAppWeb.Authorize

  def create(conn, %{"session" => session_params}) do
    case Phauxth.Login.verify(session_params, TodoApp.Accounts, crypto: Comeonin.Argon2) do
      {:ok, user} ->
        token = Phauxth.Token.sign(TodoAppWeb.Endpoint, user.id)
        render(conn, TodoAppWeb.SessionView, "info.json", %{info: token})
      {:error, _message} -> error(conn, :unauthorized, 401)
    end
  end
end
