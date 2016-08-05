defmodule TodoApp.Authorize do
  import OpenmaizeJWT.Plug
  import Plug.Conn
  import Phoenix.Controller
  alias TodoApp.{Repo, User}

  def auth_action_id(%Plug.Conn{assigns: %{current_user: nil}} = conn, _) do
    render(conn, TodoApp.ErrorView, "401.json", [])
  end
  def auth_action_id(%Plug.Conn{params: %{"user_id" => user_id} = params,
    assigns: %{current_user: current_user}} = conn, module) do
    if user_id == to_string(current_user.id) do
      apply(module, action_name(conn), [conn, params, Repo.get(User, current_user.id)])
    else
      render(conn, TodoApp.ErrorView, "403.json", [])
    end
  end

  def id_check(%Plug.Conn{assigns: %{current_user: nil}} = conn, _opts) do
    render(conn, TodoApp.ErrorView, "401.json", [])
  end
  def id_check(%Plug.Conn{params: %{"id" => id}, assigns: %{current_user:
     %{id: current_id}}} = conn, _opts) do
    id == to_string(current_id) and conn || render(conn, TodoApp.ErrorView, "403.json", [])
  end

  def handle_login(%Plug.Conn{private: %{openmaize_error: _message}} = conn, _params) do
    render(conn, TodoApp.ErrorView, "401.json", [])
  end
  def handle_login(%Plug.Conn{private: %{openmaize_user: user}} = conn, _params) do
    add_token(conn, user, :username) |> send_resp
  end

  def handle_logout(%Plug.Conn{private: %{openmaize_info: message}} = conn, _params) do
    logout_user(conn)
    |> render(TodoApp.UserView, "info.json", %{info: message})
  end
end
