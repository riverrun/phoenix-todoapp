defmodule TodoAppWeb.AuthCase do
  use Phoenix.ConnTest

  alias TodoApp.Accounts

  def add_user(email) do
    user = %{email: email, password: "mangoes&g0oseberries"}
    {:ok, user} = Accounts.create_user(user)
    user
  end

  def add_token_conn(conn, user) do
    secret = TodoAppWeb.Endpoint.config(:secret_key_base)
    conn = put_in(conn.secret_key_base, secret)
    user_token = Phauxth.Token.sign(conn, user.id)
    conn
    |> put_req_header("accept", "application/json")
    |> put_req_header("authorization", user_token)
  end
end
