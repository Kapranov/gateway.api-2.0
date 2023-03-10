defmodule SmsRouter.MixProject do
  use Mix.Project

  def project do
    [
      app: :sms_router,
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
      mod: {SmsRouter.Application, []}
    ]
  end

  defp deps do
    [
      {:core, in_umbrella: true},
      {:excoveralls, "~> 0.14", only: :test},
      {:jason, "~> 1.2"},
      {:redix, "~> 1.1"}
    ]
  end
end
