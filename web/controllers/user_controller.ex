defmodule TodoApp.UserController do
  use TodoApp.Web, :controller

  import Openmaize.AccessControl
  alias TodoApp.User

  plug Openmaize.Login, [storage: nil] when action in [:login]
  plug :authorize_id, [redirects: false] when action in [:delete]

  def index(conn, _params) do
    users = Repo.all(User)
    render(conn, "index.json", users: users)
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get(User, id)
    render(conn, "show.json", user: user)
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.auth_changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", user_path(conn, :show, user))
        |> render("show.json", user: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(TodoApp.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Repo.get(User, id)
    Repo.delete!(user)

    send_resp(conn, :no_content, "")
  end
end
