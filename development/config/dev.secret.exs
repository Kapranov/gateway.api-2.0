use Mix.Config

config :core, Core.Repo,
  database: "messages_gateway",
  hostname: "localhost",
  password: "postgres",
  pool_size: 10,
  username: "postgres"
