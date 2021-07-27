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
  """)
end
