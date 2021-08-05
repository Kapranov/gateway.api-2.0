use Mix.Config

root_path = Path.expand("../config/", __DIR__)
file_path = "#{root_path}/test.secret.exs"

if File.exists?(file_path) do
  import_config "test.secret.exs"
else
  File.write(file_path, """
  use Mix.Config

  config :core, Core.Repo,
    database: "your_name_db",
    hostname: "your_hostname",
    password: "your_password",
    pool: Ecto.Adapters.SQL.Sandbox,
    pool_size: 10,
    username: "your_login"

  config :core, Core.Repo,
    username: "your_name_db",
    password: "your_password",
    database: "your_name_db",
    hostname: "your_hostname",
    show_sensitive_data_on_connection_error: true,
    pool: Ecto.Adapters.SQL.Sandbox

  config :msg_router, MsgRouter.MqManager,
    mq_modul: MqManagerTest,
    mq_host: "your_hostname",
    mq_port: "5672",
    mq_queue:  "message_queue",
    mq_exchange: "message_exchange"

  config :msg_router, MsgRouter.RedisManager,
    host: "your_hostname",
    database: "your_name_db",
    password: "your_password",
    port: "6379",
    pool_size: "5"

  config :mg_logger, elasticsearch_url: "http://127.0.0.1:9200"
  """)
end
