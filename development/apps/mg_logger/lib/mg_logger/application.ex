defmodule MgLogger.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {MgLogger.Server, []}
    ]
    opts = [strategy: :one_for_one, name: MgLogger.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
