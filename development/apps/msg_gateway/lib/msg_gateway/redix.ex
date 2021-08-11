defmodule RedixSupervisor do
  @moduledoc false

  use Supervisor
  require Logger

  @name __MODULE__

  def start_link(children_redix) do
    Logger.info("RedixSupervisor Start Link")
    Supervisor.start_link(@name, children_redix, name: @name)
  end

  def init(children_redix) do
    children = children_redix
    Supervisor.init(children, strategy: :one_for_one)
  end
end
