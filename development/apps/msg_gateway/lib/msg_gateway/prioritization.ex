defmodule MsgGateway.Prioritization do
  @moduledoc false

  alias MsgGateway.RedisManager
  alias MsgGatewayInit

  @messages_gateway_conf "system_config"
  @operators_config "operators_config"
  @type priority_type() :: %{
    id: String.t(),
    protocol_name: String.t(),
    priority: integer(),
    operator_priority: integer(),
    configs: map(),
    limit: integer(),
    active_protocol_type: boolean(),
    active: boolean()
  }

  @type priority_list() :: [priority_type()]

  @spec get_message_priority_list() :: result when
          result: {:ok, {:error, any()} | priority_list()}
  def get_message_priority_list() do
    with _messages_gateway_conf <- RedisManager.get(@messages_gateway_conf),
         operators_type_config <- RedisManager.get(@operators_config)
      do
      priority_list = Enum.filter(operators_type_config, &(&1.protocol_name != "smtp_protocol"))
      {:ok, priority_list}
    end
  end

  @spec get_smtp_priority_list() :: result when
          result: {:ok,  {:error, any()} | priority_list()}
  def get_smtp_priority_list() do
    with _messages_gateway_conf <- RedisManager.get(@messages_gateway_conf),
         operators_type_config <- RedisManager.get(@operators_config)
      do
      priority_list = Enum.filter(operators_type_config, &(&1.protocol_name == "smtp_protocol"))
      {:ok, priority_list}
    end
  end

  @spec get_priority_list(protocol_name) :: result when
          protocol_name: String.t(),
          result: {:ok,  [nil] | priority_list()}
  def get_priority_list(protocol_name) do
    with operators_type_config <- RedisManager.get(@operators_config) do
      {:ok, [Enum.find(operators_type_config, &(&1.protocol_name == protocol_name))]}
    end
  end
end
