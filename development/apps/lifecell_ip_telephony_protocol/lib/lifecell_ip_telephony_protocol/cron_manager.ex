defmodule LifecellIpTelephonyProtocol.CronManager do
  @moduledoc false

  use GenServer

  @name __MODULE__

  def start_link(opts \\ %{}), do: GenServer.start_link(@name, opts, name: @name)

  def init(state), do: {:ok, state}

  def handle_info({:check_status, message_info}, state) do
    LifecellSmsProtocol.check_message_status(message_info)
    {:noreply, state}
  end
end
