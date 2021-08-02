use Mix.Config

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
