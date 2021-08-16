use Mix.Config

config :mg_logger, elasticsearch_url: "http://127.0.0.1:9200"
# config :logger, handle_otp_reports: false
config :lager, error_logger_redirect: false, handlers: [level: :critical]

config :core, Core.Repo,
  database: "messages_gateway_test",
  hostname: "localhost",
  password: "postgres",
  pool: Ecto.Adapters.SQL.Sandbox,
  show_sensitive_data_on_connection_error: true,
  username: "postgres"

config :msg_router, MsgRouter.MqManager,
  mq_exchange: "message_exchange",
  mq_host: "localhost",
  mq_modul: MqManagerTest,
  mq_port: "5672",
  mq_queue:  "message_queue"

config :msg_router, MsgRouter.RedisManager,
  database: "2",
  host: "localhost",
  password: nil,
  pool_size: "5",
  port: "6379"

config :msg_gateway, MsgGatewayWeb.Endpoint,
  http: [port: 4001],
  server: false

config :msg_gateway, MsgGateway.MqManager,
  mq_exchange: "message_exchange",
  mq_host: "127.0.0.1",
  mq_modul: MqManagerTest,
  mq_port: "5672",
  mq_queue:  "message_queue"

config :msg_gateway, MsgGateway.RedisManager,
  database: "2",
  host: "0.0.0.0",
  password: nil,
  pool_size: "5",
  port: 6379

config :logger, level: :warn

config :msg_gateway, MsgGatewayWeb.KeysController,
  dets_file_name: :mydata_file_test

config :sms_router, SmsRouter.RedisManager,
  database: "2",
  host: "localhost",
  password: nil,
  pool_size: "5",
  port: "6379"

config :viber_protocol,
  auth_token: "48f01d9268e7d064-5c8b70def6243721-a025fd7b15cb0902"

config :viber_protocol,  ViberProtocol.RedisManager,
  database: "2",
  host: "127.0.0.1",
  password: nil,
  pool_size: "5",
  port: "6379"

config :viber_protocol,
  callback_port: "6012"

config :viber_protocol,
  viber_endpoint: TestEndpoint
