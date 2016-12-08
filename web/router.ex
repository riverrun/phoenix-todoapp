defmodule TodoApp.Router do
  use TodoApp.Web, :router

  @max_age 24 * 60 * 60

  pipeline :api do
    plug :accepts, ["json"]
    plug :get_token
  end

  scope "/api", TodoApp do
    pipe_through :api

    resources "/sessions", SessionController, only: [:new, :create, :delete]
    resources "/users", UserController, except: [:new, :edit] do
      resources "/todos", TodoController, except: [:new, :edit]
    end
  end

  defp get_token(%Plug.Conn{req_headers: headers} = conn, _opts) do
    case List.keyfind(headers, "authorization", 0) do
      {_, token} -> verify_token(conn, token)
      nil -> assign(conn, :current_user, nil)
    end
  end

  defp verify_token(conn, token) do
    case Phoenix.Token.verify(TodoApp.Endpoint, "user token", token, max_age: @max_age) do
      {:ok, user_id} -> assign(conn, :current_user, user_id)
      {:error, _reason} -> assign(conn, :current_user, nil)
    end
  end
end
