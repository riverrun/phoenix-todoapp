defmodule TodoAppWeb.Authorize do

  import Plug.Conn
  import Phoenix.Controller

  def auth_action(%Plug.Conn{assigns: %{current_user: nil}} = conn, _) do
    error(conn, :unauthorized, 401)
  end
  def auth_action(%Plug.Conn{assigns: %{current_user: current_user},
    params: params} = conn, module) do
    apply(module, action_name(conn), [conn, params, current_user])
  end

  def auth_action_id(%Plug.Conn{params: %{"user_id" => user_id} = params,
    assigns: %{current_user: %{id: id} = current_user}} = conn, module) do
    if user_id == to_string(id) do
      apply(module, action_name(conn), [conn, params, current_user])
    else
      error(conn, :forbidden, 403)
    end
  end
  def auth_action_id(conn, _), do: error(conn, :unauthorized, 401)

  def user_check(%Plug.Conn{assigns: %{current_user: nil}} = conn, _opts) do
    error(conn, :unauthorized, 401)
  end
  def user_check(conn, _opts), do: conn

  def id_check(%Plug.Conn{assigns: %{current_user: nil}} = conn, _opts) do
    error(conn, :unauthorized, 401)
  end
  def id_check(%Plug.Conn{params: %{"id" => id},
      assigns: %{current_user: current_user}} = conn, _opts) do
    if id == to_string(current_user.id) do
      conn
    else
      error(conn, :forbidden, 403)
    end
  end

  def success(conn, message, path) do
    conn
    |> put_flash(:info, message)
    |> redirect(to: path)
  end

  def error(conn, status, code) do
    put_status(conn, status)
    |> render(TodoAppWeb.AuthView, "#{code}.json", [])
    |> halt
  end
end
