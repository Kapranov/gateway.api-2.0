defmodule MsgGatewayWeb.SystemConfigController do
  @moduledoc false

  use MsgGatewayWeb, :controller

  alias MsgGateway.RedisManager
  action_fallback(MsgGatewayWeb.FallbackController)

  @messages_gateway_conf "system_config"

  @typep conn() :: Plug.Conn.t()
  @typep result() :: Plug.Conn.t()

  @spec index(conn, params) :: result when
          conn:   conn(),
          params: map(),
          result: result()
  def index(conn, _params) do
    with system_config <- RedisManager.get(@messages_gateway_conf)
      do
      render(conn, "index.json",  %{:config => system_config})
    end
  end

  @spec add(conn, params) :: result when
          conn:   conn(),
          params:  %{resource: map()},
          result: result()
  def add(conn, %{"resource" => sys_config}) do
    with :ok <- RedisManager.set(@messages_gateway_conf, sys_config)
      do
        render(conn, "change_system_config.json", %{status: :ok})
    end
  end
end
