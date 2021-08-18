defmodule VodafonSmsProtocol do
  @moduledoc  false

  use GenServer

  alias VodafonSmsProtocol.RedisManager

  @name __MODULE__

  @protocol_config_def %{
    code: "",
    login: "",
    method_name: :send_message,
    module_name: @name,
    password: "",
    sms_price_for_external_operator: 0
  }

  def start_link(opts \\ []), do: GenServer.start_link(@name, opts, name: @name)

  def init(_opts) do
    {:ok, app_name} = :application.get_application(@name)

    RedisManager.get(Atom.to_string(app_name))
    |> check_config(app_name)

    GenServer.cast(MgLogger.Server, {:log, @name, %{"#{@name}" => "started"}})

    {:ok, []}
  end

  defp check_config({:error, _}, app_name), do: RedisManager.set(Atom.to_string(app_name), @protocol_config_def)
  defp check_config(protocol_config, app_name) do
    case Map.keys(protocol_config) == Map.keys(@protocol_config_def) do
      true -> :ok
      _->
        config = for {k, v} <- @protocol_config_def, into: %{}, do: {k, Map.get(protocol_config, k, v)}
        RedisManager.set(Atom.to_string(app_name), config)
    end
  end

  def send_message(message_info), do: end_sending_messages(message_info)

  defp end_sending_messages(message_info) do
    :io.format("Vodafon SMS error sending message")
    GenServer.cast(MgLogger.Server, {:log, @name, %{"#{@name}" => "not supported"}})
    apply(:'Elixir.MessagesRouter', :send_message, [%{message_id: message_info.message_id}])
  end
end
