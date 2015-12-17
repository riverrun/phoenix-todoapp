defmodule TodoApp.Mixfile do
  use Mix.Project

  def project do
    [app: :todo_app,
     version: "0.1.0",
     elixir: "~> 1.0",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases,
     deps: deps]
  end

  def application do
    [mod: {TodoApp, []},
     applications: [:phoenix, :cowboy, :logger,
                    :phoenix_ecto, :postgrex, :comeonin, :openmaize]]
  end

  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  defp deps do
    [{:phoenix, "~> 1.1"},
     {:phoenix_ecto, "~> 2.0"},
     {:postgrex, ">= 0.0.0"},
     {:comeonin, "~> 2.0"},
     {:openmaize, git: "https://github.com/elixircnx/openmaize.git", branch: "develop"},
     {:cowboy, "~> 1.0"}]
  end

  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"]]
  end
end
