use Mix.Config

config :mg_logger, elasticsearch_url: "http://127.0.0.1:9200"
# config :logger, handle_otp_reports: false
config :lager, error_logger_redirect: false, handlers: [level: :critical]

config :core, Core.Repo,
  username: "postgres",
  password: "postgres",
  database: "messages_gateway_test",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool: Ecto.Adapters.SQL.Sandbox

config :msg_router, MsgRouter.MqManager,
  mq_modul: MqManagerTest,
  mq_host: "localhost",
  mq_port: "5672",
  mq_queue:  "message_queue",
  mq_exchange: "message_exchange"

config :msg_router, MsgRouter.RedisManager,
  host: "localhost",
  database: "2",
  password: nil,
  port: "6379",
  pool_size: "5"

config :msg_gateway, MsgGatewayWeb.Endpoint,
  http: [port: 4001],
  server: false

config :msg_gateway, MsgGateway.MqManager,
  mq_modul: MqManagerTest,
  mq_host: "127.0.0.1",
  mq_port: "5672",
  mq_queue:  "message_queue",
  mq_exchange: "message_exchange"

config :msg_gateway, MsgGateway.RedisManager,
  host: "0.0.0.0",
  database: "2",
  password: nil,
  port: 6379,
  pool_size: "5"

config :logger, level: :warn

config :msg_gateway, MsgGatewayWeb.KeysController,
  dets_file_name: :mydata_file_test

config :sms_router, SmsRouter.RedisManager,
  host: "localhost",
  database: "2",
  password: nil,
  port: "6379",
  pool_size: "5"
