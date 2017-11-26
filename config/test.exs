use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :todo_app, TodoAppWeb.Endpoint,
  http: [port: 4001],
  #server: false
  server: true

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :todo_app, TodoApp.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "todo_app_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# Comeonin password hashing test config
#config :argon2_elixir,
  #t_cost: 2,
  #m_cost: 8
config :bcrypt_elixir, :log_rounds, 4
#config :pbkdf2_elixir, :rounds, 1
