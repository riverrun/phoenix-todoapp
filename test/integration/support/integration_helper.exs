defmodule TodoAppWeb.IntegrationHelper do
  alias WuffWuff.Api

  def auth_get(url, token), do: Api.get!(url, [{"Authorization", token}])

  def auth_del(url, token), do: Api.delete!(url, [{"Authorization", token}])

  def auth_post(url, data, token) do
    Api.post!(url, data, [{"Authorization", token}])
  end

  def login_user(email, password \\ "mangoes&g0oseberries") do
    body = %{session: %{email: email, password: password}}
    Api.post!("/sessions", body).body
  end

end
