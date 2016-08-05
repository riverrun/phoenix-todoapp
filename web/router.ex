defmodule TodoApp.Router do
  use TodoApp.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug OpenmaizeJWT.Authenticate
  end

  scope "/api", TodoApp do
    pipe_through :api

    post "/login", UserController, :login
    resources "/users", UserController, only: [:index, :show, :create, :delete] do
      resources "/todos", TodoController, except: [:new, :edit]
    end
  end
end
