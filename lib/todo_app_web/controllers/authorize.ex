defmodule TodoAppWeb.Authorize do

  import Plug.Conn
  import Phoenix.Controller

  # This function can be used to customize the `action` function in
  # the controller so that only authenticated users can access each route.
  # See the [Authorization wiki page](https://github.com/riverrun/phauxth/wiki/Authorization)
  # for more information and examples.
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

  # Plug to only allow authenticated users to access the resource.
  # See the user controller for an example.
  def user_check(%Plug.Conn{assigns: %{current_user: nil}} = conn, _opts) do
    error(conn, :unauthorized, 401)
  end
  def user_check(conn, _opts), do: conn

  # Plug to only allow unauthenticated users to access the resource.
  # See the session controller for an example.
  def guest_check(%Plug.Conn{assigns: %{current_user: nil}} = conn, _opts), do: conn
  def guest_check(%Plug.Conn{assigns: %{current_user: _current_user}} = conn, _opts) do
    put_status(conn, :unauthorized)
    |> render(TodoAppWeb.AuthView, "logged_in.json", [])
    |> halt
  end

  # Plug to only allow authenticated users with the correct id to access the resource.
  # See the user controller for an example.
  def id_check(%Plug.Conn{assigns: %{current_user: nil}} = conn, _opts) do
    error(conn, :unauthorized, 401)
  end
  def id_check(%Plug.Conn{params: %{"id" => id},
      assigns: %{current_user: current_user}} = conn, _opts) do
    id == to_string(current_user.id) and conn || error(conn, :forbidden, 403)
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
