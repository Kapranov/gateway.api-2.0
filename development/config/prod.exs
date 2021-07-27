use Mix.Config

root_path = Path.expand("../config/", __DIR__)
file_path = "#{root_path}/prod.secret.exs"

if File.exists?(file_path) do
  import_config "prod.secret.exs"
else
  File.write(file_path, """
  use Mix.Config

  config :core, Core.Repo,
    database: "${DB_NAME}",
    hostname: "${DB_HOST}",
    password: "${DB_PASSWORD}",
    pool_size: "${DB_POOL_SIZE}",
    pool_timeout: 15_000,
    port: "${DB_PORT}",
    timeout: 15_000,
    username: "${DB_USER}"
  """)
end
