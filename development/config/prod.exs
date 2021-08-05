use Mix.Config

root_path = Path.expand("../config/", __DIR__)
file_path = "#{root_path}/prod.secret.exs"

if File.exists?(file_path) do
  import_config "prod.secret.exs"
else
  File.write(file_path, """
  use Mix.Config

  config :mg_logger, elasticsearch_url: "http://192.168.100.165:9200"
  config :logger, handle_otp_reports: false
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
    password: System.get_env("REDIS_PASSWORD"),
    host: "${REDIS_HOST}",
    port: "${REDIS_PORT}",
    pool_size: "${REDIS_POOL_SIZE}"

  config :msg_router,  MsgRouter.MqManager,
    mq_modul: MsgGateway.MqManager,
    mq_host:  "${MQ_HOST}",
    mq_port:  "${MQ_PORT}",
    resend_timeout: "{$MQ_RESEND_TIMEOUT}",
    mq_queue:  "${MQ_QUEUE}",
    mq_exchange: "${MQ_EXCHANGE}"

  config :msg_gateway, MsgGatewayWeb.Endpoint,
    load_from_system_env: true,
    http: [:inet6, port: System.get_env("PORT")],
    url: [
      host: {:system, "HOST", "localhost"},
      port: {:system, "PORT", "80"}
    ],
    debug_errors: false,
    code_reloader: false,
    server: true,
    root: "."

  config :msg_gateway, MsgGateway.RedisManager,
    database: "${REDIS_NAME}",
    password: System.get_env("REDIS_PASSWORD"),
    host: "${REDIS_HOST}",
    port: "${REDIS_PORT}",
    pool_size: "${REDIS_POOL_SIZE}"

  config :msg_gateway, MsgGateway.MqManager,
    mq_modul: MsgGateway.MqManager,
    mq_host:  "${MQ_HOST}",
    mq_port:  "${MQ_PORT}",
    resend_timeout: "${MQ_RESEND_TIMEOUT}",
    mq_queue:  "${MQ_QUEUE}",
    mq_exchange: "${MQ_EXCHANGE}"

  config :msg_gateway, MsgGatewayWeb.KeysController,
    dets_file_name: :mydata_file
  """)
end
