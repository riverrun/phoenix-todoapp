defmodule TodoApp.Router do
  use TodoApp.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug OpenmaizeJWT.Authenticate
  end

  scope "/api", TodoApp do
    pipe_through :api

    resources "/sessions", SessionController, only: [:new, :create, :delete]
    resources "/users", UserController, except: [:new, :edit] do
      resources "/todos", TodoController, except: [:new, :edit]
    end
  end
end
