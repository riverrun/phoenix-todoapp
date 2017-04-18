defmodule TodoApp.Web.AuthCase do
  use Phoenix.ConnTest

  alias TodoApp.Accounts

  def add_user(email) do
    user = %{email: email, password: "mangoes&g0oseberries"}
    {:ok, user} = Accounts.create_user(user)
    user
  end

  def add_token_conn(conn, user) do
    user_token = Phoenix.Token.sign(TodoApp.Web.Endpoint, "user auth", user.id)
    conn
    |> put_req_header("accept", "application/json")
    |> put_req_header("authorization", user_token)
  end
end
