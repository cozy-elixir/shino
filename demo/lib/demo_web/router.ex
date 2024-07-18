defmodule DemoWeb.Router do
  use DemoWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {DemoWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", DemoWeb do
    pipe_through :browser

    live "/", HomeLive
    live "/installation", HomeLive, :installation
    live "/components/button", HomeLive, :component_button

    live "/notification/introduction", HomeLive, :notification_introduction
    live "/notification/customization", HomeLive, :notification_customization
    live "/notification/recipes", HomeLive, :notification_recipes
    get "/notification/flash/dead_view", PageController, :flash_dead_view

  end
end
