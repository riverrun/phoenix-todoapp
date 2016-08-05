use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :todo_app, TodoApp.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :todo_app, TodoApp.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "dev",
  password: System.get_env("POSTGRES_PASS"),
  database: "todo_app_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# OpenmaizeJWT authentication library configuration
config :openmaize_jwt,
  signing_salt: "no one will guess this"
