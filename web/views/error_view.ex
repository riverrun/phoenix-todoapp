defmodule TodoApp.ErrorView do
  use TodoApp.Web, :view

  def render("401.json", _assigns) do
    %{errors: %{detail: "You have to login to access this page"}}
  end

  def render("403.json", _assigns) do
    %{errors: %{detail: "You are not allowed to access this page"}}
  end

  def render("404.json", _assigns) do
    %{errors: %{detail: "Page not found"}}
  end

  def render("500.json", _assigns) do
    %{errors: %{detail: "Server internal error"}}
  end

  def render("error.json", %{error: message}) do
    %{errors: %{detail: message}}
  end

  def template_not_found(_template, assigns) do
    render "500.json", assigns
  end
end
