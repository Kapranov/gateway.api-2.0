defmodule MsgGatewayWeb.ProtocolsController do
  @moduledoc false

  use MsgGatewayWeb, :controller

  action_fallback(MsgGatewayWeb.FallbackController)

  @typep conn() :: Plug.Conn.t()
  @typep result() :: Plug.Conn.t()

  @spec index(conn, params) :: result when
          conn:   conn(),
          params: map(),
          result: result()
  def index(conn, _params) do
    with {:ok, protocols} <- MsgGateway.RedisManager.keys("*_protocol")
      do
      render(conn, "protocols.json", %{protocols: protocols})
    end
  end

  @spec show(conn, show_params) :: result when
          conn:   conn(),
          show_params: %{id:  String.t()},
          result: result()
  def show(conn, %{"id" => name}) do
    with fields <- MsgGateway.RedisManager.get(name)
      do
      render(conn, "protocols.json", %{fields: fields})
    end
  end
end
