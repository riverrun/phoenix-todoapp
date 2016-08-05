defmodule TodoApp.Mixfile do
  use Mix.Project

  def project do
    [app: :todo_app,
     version: "0.4.0",
     elixir: "~> 1.2",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases(),
     deps: deps()]
  end

  def application do
    [mod: {TodoApp, []},
     applications: [:phoenix, :phoenix_pubsub, :cowboy, :logger, :gettext,
                    :phoenix_ecto, :postgrex, :openmaize_jwt]]
  end

  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  defp deps do
    [{:phoenix, "~> 1.2.0"},
     {:phoenix_pubsub, "~> 1.0"},
     {:phoenix_ecto, "~> 3.0"},
     {:postgrex, ">= 0.0.0"},
     {:openmaize_jwt, git: "https://github.com/riverrun/openmaize_jwt.git"},
     #{:openmaize_jwt, "~> 1.0"},
     {:gettext, "~> 0.11"},
     {:cowboy, "~> 1.0"}]
  end

  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"],
     "test": ["ecto.create --quiet", "ecto.migrate", "test"]]
  end
end
