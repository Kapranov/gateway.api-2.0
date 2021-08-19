use Mix.Config

config :mg_logger, elasticsearch_url: "http://127.0.0.1:9200"

config :logger, handle_otp_reports: false, level: :warn
config :lager, error_logger_redirect: false, handlers: [level: :critical]

config :phoenix, :stacktrace_depth, 20

config :phoenix, :plug_init_mode, :runtime

config :core, Core.Repo,
  database: "messages_gateway",
  hostname: "localhost",
  password: "postgres",
  pool_size: 10,
  username: "postgres"

config :msg_router, MsgRouter.MqManager,
  mq_exchange: "message_exchange",
  mq_host: "localhost",
  mq_modul: MsgGateway.MqManager,
  mq_port: "5672",
  mq_queue:  "message_queue"

config :msg_router, MsgRouter.RedisManager,
  database: "1",
  host: "localhost",
  password: nil,
  pool_size: "5",
  port: "6379"

config :msg_gateway, MsgGatewayWeb.Endpoint,
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  http: [port: 4000],
  watchers: []

config :msg_gateway, MsgGateway.MqManager,
  mq_exchange: "message_exchange",
  mq_host: "127.0.0.1",
  mq_modul: MsgGateway.MqManager,
  mq_port: "5672",
  mq_queue:  "message_queue"

config :msg_gateway, MsgGateway.RedisManager,
  database: nil,
  host: "0.0.0.0",
  password: nil,
  pool_size: "5",
  port: 6379

config :msg_gateway, MsgGatewayWeb.KeysController,
  dets_file_name: :mydata_file

config :sms_router, SmsRouter.RedisManager,
  database: "1",
  host: "127.0.0.1",
  password: nil,
  pool_size: "5",
  port: "6379"

config :viber_protocol,
  auth_token: "4933484972a7d4e7-fc167580a909f0c6-d93108225af8ea6a"

config :viber_protocol,  ViberProtocol.RedisManager,
  database: "1",
  host: "127.0.0.1",
  password: nil,
  pool_size: "5",
  port: "6379"

config :viber_protocol,
  callback_port: "6012"

config :viber_protocol,
  viber_endpoint: ViberEndpoint

config :telegram_protocol,  TelegramProtocol.RedisManager,
  database: "1",
  host: "127.0.0.1",
  password: nil,
  pool_size: "5",
  port: "6379"

config :telegram_protocol, TelegramProtocol,
  telegram_driver: TDLib

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
  smtp_mailer: SmtpProtocol.Mailer,
  ssl: false,
  tls: :if_available,
  username: "r.moroz@skywell.software"

config :smtp_protocol, SmtpProtocol.RedisManager,
  database: "1",
  host: "127.0.0.1",
  password: nil,
  pool_size: "5",
  port: "6379"

config :vodafon_sms_protocol,  VodafonSmsProtocol.RedisManager,
  database: "1",
  host: "127.0.0.1",
  password: nil,
  pool_size: "5",
  port: "6379"

config :lifecell_sms_protocol,
  login: nil,
  password: nil,
  sms_send_url: "http://bulk.bs-group.com.ua/clients.php"

config :lifecell_sms_protocol,  LifecellSmsProtocol.RedisManager,
  database: "1",
  host: "127.0.0.1",
  password: nil,
  pool_size: "5",
  port: "6379"

config :lifecell_sms_protocol,
  callback_port: "6016"

config :lifecell_sms_protocol,
  endpoint: LifecellSmsProtocol.EndpointManager

config :ex_ami, servers: [
  {:asterisk, [
    {:connection, {ExAmi.TcpConnection, [
      {:host, "127.0.0.1"}, {:port, 5038}
    ]}},
    {:username, "elixirconf"},
    {:secret, "elixirconf"}
  ]}
]

config :lifecell_ip_telephony_protocol, LifecellIpTelephonyProtocol.RedisManager,
  database: nil,
  host: "0.0.0.0",
  password: nil,
  pool_size: "5",
  port: "6379"
