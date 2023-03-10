defmodule MsgGatewayWeb.OperatorsController do
  @moduledoc false

  use MsgGatewayWeb, :controller

  alias Core.{
    Operators,
    OperatorsRequests
  }
  alias MsgGateway.RedisManager

  action_fallback(MsgGatewayWeb.FallbackController)

  @operation_info "operators_info"

  @typep conn() :: Plug.Conn.t()
  @typep result() :: Plug.Conn.t()
  @type operator_info_for_redis()  :: %{
    id: String.t(),
    active: boolean(),
    name: String.t(),
    priority: integer(),
   limit: integer()
  }

  @spec index(conn, params) :: result when
          conn:   conn(),
          params: map(),
          result: result()
  def index(conn, _params) do
    with operators <- OperatorsRequests.list_operators()
      do
      updated_operators =
        Enum.map(operators, fn(x) ->
          operator_map = Map.from_struct(x.operator)
          operator_config = RedisManager.get(operator_map.protocol_name)
          new_config = Map.merge(operator_map.config, operator_config)
          update_operator = put_in(operator_map[:config], new_config)
          put_in(x[:operator], update_operator)
        end)
        render(conn, "index.json", %{operators: updated_operators})
    end
  end

  @spec create(conn, create_params) :: result when
          conn:   conn(),
          create_params: %{resource: %{
            name: String.t(),
            operator_type_id: String.t(),
            protocol_name: String.t(),
            config: map(),
            priority: integer(),
            price: integer(),
            limit: integer(),
            active: boolean()
          }},
          result: result()
  def create(conn, %{"resource" => operator_info_resp}) do
    operator_info = check_required_fuilds(Map.has_key?(operator_info_resp, "config"), operator_info_resp)
    with {:ok, _} <- OperatorsRequests.add_operator(operator_info) do
      MsgGatewayInit.set_operators_config()
      render(conn, "create.json", %{status: "success"})
    end
  end

  @spec change_info(conn, create_params) :: result when
          conn:   conn(),
          create_params: %{resource: %{
            id: String.t(),
            active: boolean(),
            config: map(),
            limit: integer(),
            name:  String.t(),
            operator_type: map(),
            price: integer(),
            priority: integer()
          }},
          result: result()
  def change_info(conn, %{"resource" => %{"id" => id} = operator_info_resp}) do
    operator_info = %{"config" => config} = check_required_fuilds(Map.has_key?(operator_info_resp, "config"), operator_info_resp)
    {_, operator_info_r} = Map.split(operator_info, ["id", "operator_type", "config"])
    with {1, _} <- OperatorsRequests.change_operator(id, [{:config, config} | convert(operator_info_r)])
      do
        OperatorsRequests.list_operators()
        |> select_operator([])
        |> add_operators_info_to_redis()

        operator_info = OperatorsRequests.operator_by_id(id)
        update_protocol_config(operator_info.protocol_name, config)
        MsgGatewayInit.set_operators_config()
        render(conn, "create.json", %{status: "success"})
    end
  end

  def check_required_fuilds(true, operator_info), do: operator_info
  def check_required_fuilds(_, operator_info), do: Map.put(operator_info, "config", Map.new)

  @spec select_operator(list_operators, select_operator_list) :: result when
          list_operators: [Operators.t()] | [] | {:error, Ecto.Changeset.t()},
          select_operator_list: [] | [operator_info_for_redis()],
          result: [] | [operator_info_for_redis()]
  def select_operator([], acc), do: acc
  def select_operator([%{operator: operator_struct}| t], acc) do
    operator = Map.from_struct(operator_struct)
    select_operator(t, [Map.merge(%{id: operator.id, active: operator.active, name: operator.name,
      priority: operator.priority, limit: operator.limit}, operator.config) | acc])
  end

  @spec add_operators_info_to_redis(list_operators) :: result when
          list_operators: [] | [operator_info_for_redis()],
          result: :ok | :error

  def add_operators_info_to_redis(list_operators) do
    json = Jason.encode!(list_operators)
    MsgGateway.RedisManager.set(@operation_info, json)
  end

  @spec delete(conn, delete_params) :: result when
          conn:   conn(),
          delete_params: %{id: String.t()},
          result: result()
  def delete(conn, %{"id" => id}) do
    with {_, nil} <- OperatorsRequests.delete(id)
      do
        render(conn, "delete.json", %{status: "success"})
    end
  end

  @spec show(conn, show_params) :: result when
          conn:   conn(),
          show_params: %{id: String.t()},
          result: result()
  def show(conn, %{"id" => id}) do
    with result <- OperatorsRequests.operator_by_id(id)
      do
      render(conn, "show.json", %{operator: result})
    end
  end

  def update_protocol_config(protocol_name, config) do
    old_config = RedisManager.get(protocol_name)
    config_key_atom = for {key, val} <- config, into: %{}, do: {String.to_atom(key), val}
    new_config =
      case Map.keys(config_key_atom) ==  Map.keys(old_config) do
        true -> Map.merge(old_config, config_key_atom)
        _->
          for {k, v} <- old_config, into: %{}, do: {k, Map.get(config_key_atom, k, v)}
      end
    RedisManager.set(protocol_name, new_config)
  end

  @spec convert(value) :: result when
          value:  map() | any(),
          result: keyword()
  defp convert(map) when is_map(map), do: Enum.map(map, fn {k,v} -> {String.to_atom(k),convert(v)}  end)
  defp convert(v), do: v
end
