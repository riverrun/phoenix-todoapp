defmodule TodoAppWeb.SessionController do
  use TodoAppWeb, :controller

  import TodoAppWeb.Authorize
  alias TodoApp.Accounts
  alias Phauxth.Login

  plug(:guest_check when action in [:create])

  # If you are using Argon2 or Pbkdf2, add crypto: Comeonin.Argon2
  # or crypto: Comeonin.Pbkdf2 to Login.verify (after Accounts)
  def create(conn, %{"session" => params}) do
    case Login.verify(params, Accounts) do
      {:ok, user} ->
        token = Phauxth.Token.sign(conn, user.id)
        render(conn, "info.json", %{info: token})

      {:error, _message} ->
        error(conn, :unauthorized, 401)
    end
  end
end
