defmodule MsgGatewayInit do
  @moduledoc false

  use GenServer

  alias MsgGateway.RedisManager
  alias Core.OperatorsRequests

  @name __MODULE__
  @messages_gateway_conf "system_config"
  @operators_config "operators_config"
  @sys_config %{
    default_sms_operator: "",
    org_name: "test",
    sending_time: "60",
    automatic_prioritization: false,
    sms_router_module: "Elixir.SmsRouter",
    sms_router_method: "check_and_send"
  }

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

  @spec start_link(list()) :: result when
          result: {:ok, pid()} |
                  :ignore |
                  {:error, {:already_started, pid()} |
                  {:shutdown, term()} |
                  term()}
  def start_link(opts \\ []) do
    GenServer.start_link(@name, opts, name: @name)
  end

  @spec init(opts) :: result when opts: term(), result: {:ok, []}
  def init(_opts) do
    RedisManager.get(@messages_gateway_conf)
    |> check_and_set_system_config()

    set_operators_config()
    select_protocol_config()
    {:ok, []}
  end

  @spec handle_info(msg, state) :: result when
          msg: :timeout | term(),
          state: term(),
          result:  {:noreply, []} |
                   {:noreply, [], timeout() |
                   :hibernate |
                   {:continue, term()}} |
                   {:stop, term(), term()}
  def handle_info(_msg, state), do: {:noreply, state}

  defp check_and_set_system_config({:error, _}), do: set_system_config()
  defp check_and_set_system_config(system_config) do
    case Map.keys(system_config) ==  Map.keys(@sys_config) do
      true -> :ok
      _->
        config = for {k, v} <- @sys_config, into: %{}, do: {k, Map.get(system_config, k, v)}
        RedisManager.set(@messages_gateway_conf, config)
    end
  end

   def set_system_config() do
    RedisManager.set(@messages_gateway_conf, @sys_config)
  end

  def set_operators_config() do
    RedisManager.set(@operators_config,  create_operators_list_to_redis())
  end

  @spec create_operators_list_to_redis() :: result when
          result: [] | priority_list()
  def create_operators_list_to_redis() do
    OperatorsRequests.list_operators()
    |> create_priority_list([])
  end

  @spec create_priority_list(list_operators, acc) :: result when
          list_operators: OperatorsRequests.operators_list() | [],
          acc: [] | priority_list(),
          result: [] | priority_list()
  defp create_priority_list([], acc), do: acc
  defp create_priority_list([operator_config_map | tail], acc) do
    priority = %{
      id: operator_config_map.operator.id,
      protocol_name: operator_config_map.operator.protocol_name,
      priority: operator_config_map.operator_type.priority,
      operator_priority: operator_config_map.operator.priority,
      configs: operator_config_map.operator.config,
      limit: operator_config_map.operator.limit,
      active_protocol_type: operator_config_map.operator_type.active,
      active: operator_config_map.operator.active}
    create_priority_list(tail, [priority | acc])
  end

  defp select_protocol_config do
    RedisManager.keys("*_protocol")
    OperatorsRequests.list_operators()
  end
end
