use Mix.Config

root_path = Path.expand("../config/", __DIR__)
file_path = "#{root_path}/test.secret.exs"

if File.exists?(file_path) do
  import_config "test.secret.exs"
else
  File.write(file_path, """
  use Mix.Config

  config :mg_logger, elasticsearch_url: "http://127.0.0.1:9200"
  config :logger, handle_otp_reports: false, level: :warn
  config :lager, error_logger_redirect: false, handlers: [level: :critical]

  config :core, Core.Repo,
    pool: Ecto.Adapters.SQL.Sandbox,
    pool_size: 10,
    username: "your_login"

  config :core, Core.Repo,
    database: "your_name_db",
    hostname: "your_hostname",
    password: "your_password",
    pool: Ecto.Adapters.SQL.Sandbox,
    pool_size: 10,
    show_sensitive_data_on_connection_error: true,
    username: "your_login"

  config :msg_router, MsgRouter.MqManager,
    mq_exchange: "message_exchange",
    mq_host: "your_hostname",
    mq_modul: MqManagerTest,
    mq_port: "5672",
    mq_queue:  "message_queue"

  config :msg_router, MsgRouter.RedisManager,
    database: "your_name_db",
    host: "your_hostname",
    password: "your_password",
    pool_size: "5",
    port: "6379"

  config :msg_gateway, MsgGatewayWeb.Endpoint,
    http: [port: 4001],
    server: false

  config :msg_gateway, MsgGateway.MqManager,
    mq_exchange: "message_exchange",
    mq_host: "your_hostname",
    mq_modul: MqManagerTest,
    mq_port: "5672",
    mq_queue:  "message_queue"

  config :msg_gateway, MsgGateway.RedisManager,
    database: "your_name_db",
    host: "your_hostname",
    password: "your_password",
    pool_size: "5",
    port: "6379"

  config :msg_gateway, MsgGatewayWeb.KeysController,
    dets_file_name: :mydata_file_test

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
    viber_endpoint: TestEndpoint

  config :telegram_protocol,  TelegramProtocol.RedisManager,
    database: "your_name_db",
    host: "your_hostname",
    password: "your_password",
    pool_size: "5",
    port: "6379"

  config :telegram_protocol, TelegramProtocol,
    telegram_driver: TDLibTest

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
    smtp_mailer: TestMailer,
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

  config :lifecell_sms_protocol,
    login: "lifecell_sms_login",
    password: "lifecell_sms_password",
    sms_send_url: "lifecell_sms_send_url"

  config :lifecell_sms_protocol,  LifecellSmsProtocol.RedisManager,
    database: "your_name_db",
    host: "your_hostname",
    password: "your_password",
    pool_size: "5",
    port: "6379"

  config :lifecell_sms_protocol,
    callback_port: "lifecell_callback_port"

  config :lifecell_sms_protocol,
    endpoint: LifecellSmsProtocol.EndpointManager
  """)
end
