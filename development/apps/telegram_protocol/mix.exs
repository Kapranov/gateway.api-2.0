defmodule TelegramProtocol.MixProject do
  use Mix.Project

  def project do
    [
      app: :telegram_protocol,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [coveralls: :test, "coveralls.detail": :test, "coveralls.post": :test, "coveralls.html": :test],
      elixirc_paths: elixirc_paths(Mix.env),
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {TelegramProtocol.Application, []}
    ]
  end

  defp deps do
    [
      {:core, in_umbrella: true},
      {:excoveralls, "~> 0.14.2"},
      {:httpoison, "~> 1.8"},
      {:jason, "~> 1.2"},
      {:plug_cowboy, "~> 2.5"},
      {:redix, "~> 1.1"},
      {:tdlib, "~> 0.0.2"}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]
end
