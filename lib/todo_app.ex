defmodule TodoApp do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(TodoApp.Endpoint, []),
      worker(TodoApp.Repo, []),
    ]

    opts = [strategy: :one_for_one, name: TodoApp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    TodoApp.Endpoint.config_change(changed, removed)
    :ok
  end
end
