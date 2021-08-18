defmodule VodafonSmsProtocol.MixProject do
  use Mix.Project

  def project do
    [
      app: :vodafon_sms_protocol,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [coveralls: :test, "coveralls.detail": :test, "coveralls.post": :test, "coveralls.html": :test],
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {VodafonSmsProtocol.Application, []}
    ]
  end

  defp deps do
    [
      {:core, in_umbrella: true},
      {:excoveralls, "~> 0.14", only: :test},
      {:httpoison, "~> 1.8"},
      {:jason, "~> 1.2"},
      {:plug_cowboy, "~> 2.5"},
      {:redix, "~> 1.1"},
      {:smppex, path: "src/smppex"}
    ]
  end
end
