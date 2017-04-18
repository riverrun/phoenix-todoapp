defmodule TodoApp.Web.Router do
  use TodoApp.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug Phauxth.Authenticate, context: TodoApp.Web.Endpoint
  end

  scope "/api", TodoApp.Web do
    pipe_through :api

    post "/sessions/create", SessionController, :create
    resources "/users", UserController, except: [:new, :edit] do
      resources "/todos", TodoController, except: [:new, :edit]
    end
  end
end
