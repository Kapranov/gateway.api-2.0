defmodule SmtpProtocol.MixProject do
  use Mix.Project

  def project do
    [
      app: :smtp_protocol,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [coveralls: :test, "coveralls.detail": :test, "coveralls.post": :test, "coveralls.html": :test],
      deps: deps(),
      elixirc_paths: elixirc_paths(Mix.env)
    ]
  end

  def application do
    [
      extra_applications: [:logger, :bamboo, :bamboo_smtp],
      mod: {SmtpProtocol.Application, []}
    ]
  end

  defp deps do
    [
      {:bamboo_smtp, "~> 4.1"},
      {:excoveralls, "~> 0.14", only: :test},
      {:redix, "~> 1.1"}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]
end
