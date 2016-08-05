defmodule TodoApp.ErrorView do
  use TodoApp.Web, :view

  def render("401.json", _assigns) do
    %{errors: %{detail: "You have to login to access this page"}}
  end

  def render("403.json", _assigns) do
    %{errors: %{detail: "You are not allowed to access this page"}}
  end

  def render("404.json", _assigns) do
    %{errors: %{detail: "page not found"}}
  end

  def render("500.json", _assigns) do
    %{errors: %{detail: "internal server error"}}
  end

  # in case no render clause matches or no
  # template is found, let's render it as 500
  def template_not_found(_template, assigns) do
    render "500.json", assigns
  end
end
