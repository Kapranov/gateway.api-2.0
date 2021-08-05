defmodule MsgGatewayWeb.Router do
  use MsgGatewayWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", MsgGatewayWeb do
    pipe_through :api
  end
end
