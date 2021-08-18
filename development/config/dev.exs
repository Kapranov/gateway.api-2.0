use Mix.Config

root_path = Path.expand("../config/", __DIR__)
file_path = "#{root_path}/dev.secret.exs"

if File.exists?(file_path) do
  import_config "dev.secret.exs"
else
  File.write(file_path, """
  use Mix.Config

  config :mg_logger, elasticsearch_url: "http://127.0.0.1:9200"
  config :logger, handle_otp_reports: false
  config :lager, error_logger_redirect: false, handlers: [level: :critical]
  config :phoenix, :stacktrace_depth, 20
  config :phoenix, :plug_init_mode, :runtime

  config :core, Core.Repo,
    database: "your_name_db",
    hostname: "your_hostname",
    password: "your_password",
    pool_size: 10,
    username: "your_login"

  config :msg_router, MsgRouter.MqManager,
    mq_exchange: "message_exchange",
    mq_host: "your_hostname",
    mq_modul: MsgGateway.MqManager,
    mq_port: "5672",
    mq_queue:  "message_queue"

  config :msg_router, MsgRouter.RedisManager,
    database: "your_name_db",
    host: "your_hostname",
    password: "your_password",
    pool_size: "5",
    port: "6379"

  config :msg_gateway, MsgGatewayWeb.Endpoint,
    check_origin: false,
    code_reloader: true,
    debug_errors: true,
    http: [port: 4000],
    render_errors: [view: EView.Views.PhoenixError, accepts: ~w(json)],
    watchers: []

  config :msg_gateway, MsgGateway.MqManager,
    mq_exchange: "message_exchange",
    mq_host: "your_hostname",
    mq_modul: MsgGateway.MqManager,
    mq_port: "5672",
    mq_queue:  "message_queue"

  config :msg_gateway, MsgGateway.RedisManager,
    database: "your_name_db",
    host: "your_hostname",
    password: "your_password",
    pool_size: "5",
    port: 6379

  config :msg_gateway, MsgGatewayWeb.KeysController,
    dets_file_name: :mydata_file

  config :sms_router, SmsRouter.RedisManager,
    database: "your_name_db",
    host: "your_hostname",
    password: "your_password",
    pool_size: "5",
    port: "6379"

  config :viber_protocol,
    auth_token: "viber_auth_token"

  config :viber_protocol,  ViberProtocol.RedisManager,
    database: "your_name_db",
    host: "your_hostname",
    password: "your_password",
    pool_size: "5",
    port: "6379"

  config :viber_protocol,
    callback_port: "6012"

  config :viber_protocol,
    viber_endpoint: ViberEndpoint

  config :telegram_protocol,  TelegramProtocol.RedisManager,
    database: "your_name_db",
    host: "your_hostname",
    password: "your_password",
    pool_size: "5",
    port: "6379"

  config :telegram_protocol, TelegramProtocol,
    telegram_driver: TDLib

  config :smtp_protocol, SmtpProtocol.Mailer,
    adapter: Bamboo.SMTPAdapter,
    allowed_tls_versions: [],
    auth: :if_available,
    hostname: "your_smtp_hostname",
    no_mx_lookups: false,
    password: "your_smtp_password",
    port: "your_smtp_port",
    retries: 1,
    server: "your_smtp_server",
    smtp_mailer: SmtpProtocol.Mailer,
    ssl: false,
    tls: :if_available,
    username: "your_smtp_username"

  config :smtp_protocol, SmtpProtocol.RedisManager,
    database: "your_name_db",
    host: "your_hostname",
    password: "your_password",
    pool_size: "5",
    port: "6379"

  config :vodafon_sms_protocol,  VodafonSmsProtocol.RedisManager,
    database: "your_name_db",
    host: "your_hostname",
    password: "your_password",
    pool_size: "5",
    port: "6379"
  """)
end
