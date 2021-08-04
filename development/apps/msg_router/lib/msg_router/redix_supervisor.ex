defmodule MsgRouter.RedixSupervisor do
  use Supervisor
  require Logger

  def start_link(children_redix) do
    Logger.info("RedixSupervisor Start Link")
    Supervisor.start_link(__MODULE__, children_redix, name: __MODULE__)
  end

  def init(children_redix) do
    children = children_redix
    Supervisor.init(children, strategy: :one_for_one)
  end
end
