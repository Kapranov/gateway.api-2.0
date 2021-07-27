use Mix.Config

config :core, Core.Repo,
  username: "postgres",
  password: "postgres",
  database: "messages_gateway_test",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool: Ecto.Adapters.SQL.Sandbox
