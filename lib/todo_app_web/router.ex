defmodule TodoAppWeb.Router do
  use TodoAppWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug Phauxth.Authenticate, method: :token
  end

  scope "/api", TodoAppWeb do
    pipe_through :api

    post "/sessions", SessionController, :create
    resources "/users", UserController, except: [:new, :edit] do
      resources "/todos", TodoController, except: [:new, :edit]
    end
  end

end
