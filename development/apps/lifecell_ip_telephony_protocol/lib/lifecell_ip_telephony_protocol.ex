defmodule LifecellIpTelephonyProtocol do
  @moduledoc false

  alias LifecellIpTelephonyProtocol.RedisManager

  @name __MODULE__
  @protocol_config %{host: "", port: ""}

  def start_link(opts \\ []), do: GenServer.start_link(@name, opts, name: @name)

  def init(_opts) do
    {:ok, app_name} = :application.get_application(@name)
    RedisManager.set(Atom.to_string(app_name), @protocol_config)
    GenServer.cast(MgLogger.Server, {:log, @name, %{"#{@name}" => "started"}})
    {:ok, []}
  end

  def send_message(%{phone: _phone} = payload) do
    try do
      GenServer.cast(MgLogger.Server, {:log, @name, %{"#{@name}" => "not supported"}})
      end_sending_messages(:error, payload)
    catch
      _ -> end_sending_messages(:error, payload)
    end
  end

  defp end_sending_messages(:error, payload), do: RedisManager.set(payload.message_id, :error)
end
