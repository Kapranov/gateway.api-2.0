defmodule MsgGatewayWeb.Router do
  @moduledoc false

  use MsgGatewayWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", MsgGatewayWeb do
    pipe_through :api
  end

  scope "/", MsgGatewayWeb do
    pipe_through :api

    get "/", DefaultController, :index
  end
end
