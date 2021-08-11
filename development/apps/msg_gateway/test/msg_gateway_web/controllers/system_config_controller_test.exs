defmodule MsgGatewayWeb.SystemConfigControllerTest do
  use MsgGatewayWeb.ConnCase, async: true
  use Core.DataCase

  test "system config", %{conn: conn} do
    {:ok, _pid} = Redix.start_link(name: :msg_gateway_0)
    
    MsgGateway.RedisManager.set("system_config", Map.new)

    result_changing_sys_config =
      select_sys_config(conn)
      |> Map.put("test", "test")
      |> add_sys_config(conn)

    assert result_changing_sys_config == "success"
  end

  defp select_sys_config(conn) do
    get(conn, "/api/system_config")
    |> json_response(200)
    |> get_in(["data"])
  end

  defp add_sys_config(sys_config, conn) do
    post(conn, "/api/system_config", %{"resource" => sys_config})
    |> json_response(200)
    |> get_in(["data", "status"])
  end
end
