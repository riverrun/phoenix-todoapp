defmodule TodoApp.Router do
  use TodoApp.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", TodoApp do
    pipe_through :api

    post "/users/login", UserController, :login
    resources "/users", UserController, only: [:show, :create, :delete]
    resources "/todos", TodoController, except: [:new, :edit]
  end
end
