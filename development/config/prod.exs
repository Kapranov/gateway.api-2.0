use Mix.Config

root_path = Path.expand("../config/", __DIR__)
file_path = "#{root_path}/prod.secret.exs"

if File.exists?(file_path) do
  import_config "prod.secret.exs"
else
  File.write(file_path, """
  use Mix.Config

  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  config :mg_logger, elasticsearch_url: "http://192.168.100.165:9200"
  config :logger, handle_otp_reports: false, level: :info
  config :lager, error_logger_redirect: false, handlers: [level: :critical]

  config :core, Core.Repo,
    database: "${DB_NAME}",
    hostname: "${DB_HOST}",
    password: "${DB_PASSWORD}",
    pool_size: "${DB_POOL_SIZE}",
    pool_timeout: 15_000,
    port: "${DB_PORT}",
    timeout: 15_000,
    username: "${DB_USER}"

  config :msg_router, MsgRouter.RedisManager,
    database: "${REDIS_NAME}",
    host: "${REDIS_HOST}",
    password: System.get_env("REDIS_PASSWORD"),
    pool_size: "${REDIS_POOL_SIZE}",
    port: "${REDIS_PORT}"

  config :msg_router,  MsgRouter.MqManager,
    mq_exchange: "${MQ_EXCHANGE}",
    mq_host:  "${MQ_HOST}",
    mq_modul: MsgGateway.MqManager,
    mq_port:  "${MQ_PORT}",
    mq_queue:  "${MQ_QUEUE}",
    resend_timeout: "{$MQ_RESEND_TIMEOUT}"

  config :msg_gateway, MsgGatewayWeb.Endpoint,
    cache_static_manifest: "priv/static/cache_manifest.json",
    code_reloader: false,
    debug_errors: false,
    http: [
      port: String.to_integer(System.get_env("PORT") || "4000"),
      transport_options: [socket_opts: [:inet6]]
    ],
    load_from_system_env: true,
    root: ".",
    secret_key_base: secret_key_base, 
    server: true,
    url: [
      host: {:system, "HOST", "localhost"},
      port: {:system, "PORT", "80"}
    ]

  config :msg_gateway, MsgGateway.RedisManager,
    database: "${REDIS_NAME}",
    host: "${REDIS_HOST}",
    password: System.get_env("REDIS_PASSWORD"),
    pool_size: "${REDIS_POOL_SIZE}",
    port: "${REDIS_PORT}"

  config :msg_gateway, MsgGateway.MqManager,
    mq_exchange: "${MQ_EXCHANGE}",
    mq_host:  "${MQ_HOST}",
    mq_modul: MsgGateway.MqManager,
    mq_port:  "${MQ_PORT}",
    mq_queue:  "${MQ_QUEUE}",
    resend_timeout: "${MQ_RESEND_TIMEOUT}"

  config :msg_gateway, MsgGatewayWeb.KeysController,
    dets_file_name: :mydata_file

  config :sms_router, SmsRouter.RedisManager,
    database: "${REDIS_NAME}",
    host: "${REDIS_HOST}",
    password: System.get_env("REDIS_PASSWORD"),
    pool_size: "${REDIS_POOL_SIZE}",
    port: "${REDIS_PORT}"

  config :viber_protocol, ViberProtocol.RedisManager,
    database: "${REDIS_NAME}",
    host: "${REDIS_HOST}",
    password: System.get_env("REDIS_PASSWORD"),
    pool_size: "${REDIS_POOL_SIZE}",
    port: "${REDIS_PORT}"

  config :viber_protocol,
    callback_port: "${VIBER_CALLBACK_PORT}"

  config :viber_protocol,
    viber_endpoint: ViberEndpoint

  config :telegram_protocol, TelegramProtocol.RedisManager,
    database: "${REDIS_NAME}",
    host: "${REDIS_HOST}",
    password: System.get_env("REDIS_PASSWORD"),
    pool_size: "${REDIS_POOL_SIZE}",
    port: "${REDIS_PORT}"

  config :telegram_protocol, TelegramProtocol,
    telegram_driver: TDLib

  config :tdlib, backend_binary: "/msg_gateway_api/lib/tdlib-0.0.2/priv/tdlib-json-cli"

  config :smtp_protocol, SmtpProtocol.Mailer,
    adapter: Bamboo.SMTPAdapter,
    allowed_tls_versions: [:tlsv1, :"tlsv1.1", :"tlsv1.2"],
    auth: :if_available,
    hostname: "${SMTP_HOSTNAME}",
    no_mx_lookups: false,
    password: "${SMTP_PASSWORD}",
    port: "${SMTP_PORT}",
    retries: 1,
    server: "${SMTP_SERVER}",
    smtp_mailer: SmtpProtocol.Mailer,
    ssl: false,
    tls: :if_available,
    username: "${SMTP_USERNAME}"

  config :smtp_protocol, SmtpProtocol.RedisManager,
    database: "${REDIS_NAME}",
    host: "${REDIS_HOST}",
    password: System.get_env("REDIS_PASSWORD"),
    pool_size: "${REDIS_POOL_SIZE}",
    port: "${REDIS_PORT}"

  config :vodafon_sms_protocol, VodafonSmsProtocol.RedisManager,
    database: "${REDIS_NAME}",
    host: "${REDIS_HOST}",
    password: System.get_env("REDIS_PASSWORD"),
    pool_size: "${REDIS_POOL_SIZE}",
    port: "${REDIS_PORT}"

  config :lifecell_sms_protocol,
    login: "${LIFECELL_SMS_LOGIN}",
    password: "${LIFECELL_SMS_PASSWORD}",
    sms_send_url: "${LIFECELL_SMS_SEND_URL}"

  config :lifecell_sms_protocol, LifecellSmsProtocol.RedisManager,
    database: "${REDIS_NAME}",
    host: "${REDIS_HOST}",
    password: System.get_env("REDIS_PASSWORD"),
    pool_size: "${REDIS_POOL_SIZE}",
    port: "${REDIS_PORT}"

  config :lifecell_sms_protocol,
    callback_port: "${LIFECELL_CALLBACK_PORT}"

  config :lifecell_sms_protocol,
    endpoint: EndpointManager
  """)
end
