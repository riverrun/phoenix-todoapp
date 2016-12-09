defmodule TodoApp.Router do
  use TodoApp.Web, :router

  import TodoApp.Auth

  pipeline :api do
    plug :accepts, ["json"]
    plug :verify_token
  end

  scope "/api", TodoApp do
    pipe_through :api

    post "/sessions/create", SessionController, :create
    resources "/users", UserController, except: [:new, :edit] do
      resources "/todos", TodoController, except: [:new, :edit]
    end
  end
end
