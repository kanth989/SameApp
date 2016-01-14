defmodule Frdapp.Router do
  use Frdapp.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Frdapp do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    # socket "/socket", Frdapp.UserSocket
  end

  # Other scopes may use custom stacks.
  # scope "/api", Frdapp do
  #   pipe_through [:api, :api_auth]
  # end
end