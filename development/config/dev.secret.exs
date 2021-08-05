use Mix.Config

config :mg_logger, elasticsearch_url: "http://127.0.0.1:9200"

# config :logger, handle_otp_reports: false
config :lager, error_logger_redirect: false, handlers: [level: :critical]

config :core, Core.Repo,
  database: "messages_gateway",
  hostname: "localhost",
  password: "postgres",
  pool_size: 10,
  username: "postgres"

config :msg_router, MsgRouter.MqManager,
       mq_modul: MsgGateway.MqManager,
       mq_host: "localhost",
       mq_port: "5672",
       mq_queue:  "message_queue",
       mq_exchange: "message_exchange"

config :msg_router, MsgRouter.RedisManager,
       host: "localhost",
       database: "1",
       password: nil,
       port: "6379",
       pool_size: "5"

config :msg_gateway, MsgGatewayWeb.Endpoint,
  http: [port: 4011],
  debug_errors: false,
  code_reloader: true,
  check_origin: false,
  render_errors: [view: EView.Views.PhoenixError, accepts: ~w(json)],
  watchers: []

config :msg_gateway, MsgGateway.MqManager,
  mq_modul: MsgGateway.MqManager,
  mq_host: "127.0.0.1",
  mq_port: "5672",
  mq_queue:  "message_queue",
  mq_exchange: "message_exchange"

config :msg_gateway, MsgGateway.RedisManager,
  host: "0.0.0.0",
  port: 6379,
  password: nil,
  database: nil,
  pool_size: "5"

config :msg_gateway, MsgGatewayWeb.KeysController,
  dets_file_name: :mydata_file
