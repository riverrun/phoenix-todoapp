defmodule TodoAppWeb.IntegrationCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      import TodoAppWeb.Router.Helpers
      alias TodoApp.Repo
      @endpoint TodoAppWeb.Endpoint
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(TodoApp.Repo)
    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(TodoApp.Repo, {:shared, self()})
    end

    :ok
  end
end
