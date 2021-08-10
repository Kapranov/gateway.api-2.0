defmodule MsgGatewayWeb.Endpoint do
  @moduledoc false

  use Phoenix.Endpoint, otp_app: :msg_gateway

  if Application.get_env(:msg_gateway, :sql_sandbox) do
    plug(Phoenix.Ecto.SQL.Sandbox)
  end

  @session_options [
    store: :cookie,
    key: "_msg_gateway_key",
    signing_salt: "GrUicUBh"
  ]

  socket "/socket", MsgGatewayWeb.UserSocket,
    websocket: true,
    longpoll: false

  plug Plug.Static,
    at: "/",
    from: :msg_gateway,
    gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)

  if code_reloading? do
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug EView.Plugs.Idempotency
  plug Plug.LoggerJSON, level: Logger.level()
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]
  plug EView

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["application/json"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug MsgGatewayWeb.Router
end
