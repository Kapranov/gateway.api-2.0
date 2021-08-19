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

config :telegram_protocol,  TelegramProtocol.RedisManager,
  database: "2",
  host: "127.0.0.1",
  password: nil,
  pool_size: "5",
  port: "6379"

config :telegram_protocol, TelegramProtocol,
  telegram_driver: TDLibTest

config :smtp_protocol, SmtpProtocol.Mailer,
  adapter: Bamboo.SMTPAdapter,
  allowed_tls_versions: [:tlsv1, :"tlsv1.1", :"tlsv1.2"],
  auth: :if_available,
  hostname: "skywell.software",
  no_mx_lookups: false,
  password: "Gembird1nser%",
  port: 587,
  retries: 1,
  server: "smtp.office365.com",
  smtp_mailer: TestMailer,
  ssl: false,
  tls: :if_available,
  username: "r.moroz@skywell.software"

config :smtp_protocol, SmtpProtocol.RedisManager,
  database: "2",
  host: "127.0.0.1",
  password: nil,
  pool_size: "5",
  port: "6379"

config :vodafon_sms_protocol,  VodafonSmsProtocol.RedisManager,
  database: "2",
  host: "127.0.0.1",
  password: nil,
  pool_size: "5",
  port: "6379"

config :lifecell_sms_protocol,
  login: "test",
  password: "test",
  sms_send_url: "http://bulk.bs-group.com.ua/clients.php"

config :lifecell_sms_protocol,  LifecellSmsProtocol.RedisManager,
  database: "2",
  host: "127.0.0.1",
  password: nil,
  pool_size: "5",
  port: "6379"

config :lifecell_sms_protocol,
  callback_port: "6016"

config :lifecell_sms_protocol,
  endpoint: LifecellSmsProtocol.EndpointManager

# config :ex_ami, servers: [ {:asterisk, [ {:connection, {ExAmi.TcpConnection, [ {:host, "127.0.0.1"}, {:port, 5038} ]}}, {:username, "elixirconf"}, {:secret, "elixirconf"} ]} ]

config :lifecell_ip_telephony_protocol,  LifecellIpTelephonyProtocol.RedisManager,
  database: "2",
  host: "127.0.0.1",
  password: nil,
  pool_size: "5",
  port: "6379"
