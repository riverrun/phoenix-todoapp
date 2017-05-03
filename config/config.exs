# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :todo_app,
  ecto_repos: [TodoApp.Repo]

# Configures the endpoint
config :todo_app, TodoApp.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "xTurykTS3CvIBdjy4uqZNg11GnW/8LmKPEoixIDjza/kDElVmk+naX3gf8xxnvQB",
  render_errors: [view: TodoApp.Web.ErrorView, accepts: ~w(json)],
  pubsub: [name: TodoApp.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phauxth,
  repo: TodoApp.Repo,
  user_mod: TodoApp.Accounts.User

config :phauxth,
  repo: TodoApp.Repo,
  user_mod: TodoApp.Accounts.User

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
