defmodule TodoApp.Router do
  use TodoApp.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug Openmaize.LoginoutCheck, redirects: false
    plug Openmaize.Authenticate, redirects: false
  end

  scope "/api", TodoApp do
    pipe_through :api

    post "/users/login", UserController, :login
    resources "/users", UserController, only: [:index, :show, :create, :delete]
    resources "/todos", TodoController, except: [:new, :edit]
  end
end
