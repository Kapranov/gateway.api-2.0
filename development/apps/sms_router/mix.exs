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
    []
  end
end
