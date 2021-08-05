defmodule MgLogger.MixProject do
  use Mix.Project

  def project do
    [
      app: :mg_logger,
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      elixir: "~> 1.12",
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
      extra_applications: [:logger, :jason],
      mod: {MgLogger.Application, []}
    ]
  end

  defp deps do
    [
      {:excoveralls, "~> 0.14", only: :test},
      {:httpoison, "~> 1.8"}
    ]
  end
end
