defmodule Core.MixProject do
  use Mix.Project

  def project do
    [
      aliases: aliases(),
      app: :core,
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      elixir: "~> 1.12",
      elixirc_paths: elixirc_paths(Mix.env),
      lockfile: "../../mix.lock",
      preferred_cli_env: [coveralls: :test, "coveralls.detail": :test, "coveralls.post": :test, "coveralls.html": :test],
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      version: "0.1.0",
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Core.Application, []}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  defp deps do
    [
      {:ecto, "~> 3.6"},
      {:ecto_logger_json, git: "https://github.com/edenlabllc/ecto_logger_json.git", branch: "query_params"},
      {:ecto_sql, "~> 3.6"},
      {:ex_machina, "~> 2.7", only: [:dev, :test]},
      {:excoveralls, "~> 0.14.2", only: :test},
      {:httpoison, "~> 1.8"},
      {:jason, "~> 1.2"},
      {:mox, "~> 1.0", only: :test},
      {:phoenix_ecto, "~> 4.3"},
      {:plug, "~> 1.12"},
      {:poison, "~> 5.0"},
      {:postgrex, "~> 0.15.9"},
      {:scrivener_ecto, "~> 2.7"},
      {:timex, "~> 3.1"}
    ]
  end

  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
