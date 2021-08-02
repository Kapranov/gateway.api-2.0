use Mix.Config

config :core, Core.Repo,
  database: "messages_gateway",
  hostname: "localhost",
  password: "postgres",
  pool_size: 10,
  username: "postgres"

config :msg_router, MsgRouter.MqManager,
       mq_modul: MsgGateway.MqManager,
       mq_host: "localhost",
       mq_port: "5672",
       mq_queue:  "message_queue",
       mq_exchange: "message_exchange"

config :msg_router, MsgRouter.RedisManager,
       host: "localhost",
       database: "1",
       password: nil,
       port: "6379",
       pool_size: "5"
