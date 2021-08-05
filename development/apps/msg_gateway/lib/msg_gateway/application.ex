defmodule MsgGateway.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      MsgGatewayWeb.Telemetry,
      {Phoenix.PubSub, name: MsgGateway.PubSub},
      MsgGatewayWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: MsgGateway.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    MsgGatewayWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
