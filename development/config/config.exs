use Mix.Config

elixir_logger_level = System.get_env("ELIXIR_LOGGER_LEVEL") || "info"

level =
  case String.downcase(elixir_logger_level) do
    s when s == "1" or s == "debug" -> :dev
    s when s == "3" or s == "warn" -> :warn
    _ -> :info
  end

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id],
  level: level,
  colors: [
    enabled: true,
    debug: :cyan,
    info: :green,
    warn: :yellow,
    error: :red
  ]

config :core, ecto_repos: [Core.Repo]

config :mg_logger, elasticsearch_url: "http://192.168.100.165:9200"

config :phoenix, :json_library, Jason

config :phoenix, :stacktrace_depth, 20

config :msg_gateway, MsgGatewayWeb.Endpoint,
  live_view: [signing_salt: "e56nxDnq"],
  pubsub_server: MsgGateway.PubSub,
  render_errors: [view: MsgGatewayWeb.ErrorView, accepts: ~w(json), layout: false],
  secret_key_base: "ibE/3gD/j0J/EZdCOb6jVPnTZyuntCEpFuwN6BHP+4VB/nRJ7L4rVJV4N2mwuCf0",
  url: [host: "localhost"]

import_config "#{Mix.env}.exs"
