defmodule TodoApp.Endpoint do
  use Phoenix.Endpoint, otp_app: :todo_app

  if code_reloading? do
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison

  plug Plug.MethodOverride
  plug Plug.Head

  plug Plug.Session,
    store: :cookie,
    key: "_todo_app_key",
    signing_salt: "ixDO3NIA"

  plug TodoApp.Router
end
