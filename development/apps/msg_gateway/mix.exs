defmodule MsgGateway.MixProject do
  use Mix.Project

  def project do
    [
      aliases: aliases(),
      app: :msg_gateway,
      build_path: "../../_build",
      compilers: [:phoenix] ++ Mix.compilers(),
      config_path: "../../config/config.exs",
      deps: deps(),
      deps_path: "../../deps",
      elixir: "~> 1.12",
      elixirc_paths: elixirc_paths(Mix.env()),
      lockfile: "../../mix.lock",
      preferred_cli_env: [coveralls: :test, "coveralls.detail": :test, "coveralls.post": :test, "coveralls.html": :test],
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      version: "0.1.0"
    ]
  end

  def application do
    [
      extra_applications: [:lager, :logger, :amqp, :runtime_tools],
      mod: {MsgGateway.Application, []}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  defp deps do
    [
      {:amqp, "~> 2.1"},
      {:core, in_umbrella: true},
      {:eview, "0.15.0"},
      {:ex_machina, "~> 2.7", only: [:dev, :test]},
      {:excoveralls, "~> 0.14", only: :test},
      {:httpoison, "~> 1.8"},
      {:jason, "~> 1.2"},
      {:mox, "~> 1.0", only: :test},
      {:phoenix, "~> 1.5.9"},
      {:plug_cowboy, "~> 2.5"},
      {:plug_logger_json, path: "src/plug_logger_json"},
      {:redix, "~> 1.1"},
      {:telemetry_metrics, "~> 0.4"},
      {:telemetry_poller, "~> 0.4"}
    ]
  end

  defp aliases do
    [
      setup: ["deps.get"]
    ]
  end
end
