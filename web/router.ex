defmodule Benanachain.Router do
  use Benanachain.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Other scopes may use custom stacks.
  scope "/api", Benanachain do
    pipe_through :api

    get "/events", PageController, :get_events

    post "/new_block", PageController, :new_block

    post "/new_event", PageController, :new_event

    get "/ping", PageController, :ping
  end
end
