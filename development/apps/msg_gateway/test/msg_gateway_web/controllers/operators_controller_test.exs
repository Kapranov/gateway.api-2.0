defmodule MsgGatewayWeb.OperatorsControllerTest do
  use MsgGatewayWeb.ConnCase
  use Core.DataCase

  @test_type "test_sms_type"

  test "check operators functionality", %{conn: conn} do
    assert create_operator_type(@test_type, conn) == "success"

    operator_type_info =
      select_all_operator_type(conn)
      |> Enum.find(&(get_in(&1, ["name"]) == @test_type))

    assert operator_type_info != nil

    MsgGateway.RedisManager.set("test", %{})

    create_operator(operator_type_info, "test", conn)
    operator_info =
      select_all_operator(conn)
      |> Enum.find(&(get_in(&1, ["name"]) == "test"))

    assert operator_info != nil

    delete_operator(operator_info, conn)

    is_delete_operator =
      select_all_operator(conn)
      |> Enum.find(&(get_in(&1, ["name"]) == @test_type))

    assert is_delete_operator == nil

    delete_operator_type(operator_type_info, conn)

    is_delete_type =
      select_all_operator_type(conn)
      |> Enum.find(&(get_in(&1, ["name"]) == @test_type))

    assert is_delete_type == nil
    assert {:ok, 1} == MsgGateway.RedisManager.del("test")
  end

  test "operators change info", %{conn: conn} do
    assert create_operator_type("test_for_change_type", conn) == "success"

    operator_type_info =
      select_all_operator_type(conn)
      |> Enum.find(&(get_in(&1, ["name"]) == "test_for_change_type"))

    assert operator_type_info != nil

    MsgGateway.RedisManager.set("test_for_change", %{})

    create_operator(operator_type_info, "test_for_change", conn)

    operator_info =
      select_all_operator(conn)
      |> Enum.find(&(get_in(&1, ["name"]) == "test_for_change"))

    assert operator_info != nil

    change_operator(operator_info, conn)

    changed_limit =
      select_all_operator(conn)
      |> Enum.find(&(get_in(&1, ["name"]) == "test_for_change"))
      |> get_in(["limit"])

    assert changed_limit == 20

    delete_operator(operator_info, conn)

    is_delete_operator =
      select_all_operator(conn)
      |> Enum.find(&(get_in(&1, ["name"]) == "test_for_change"))

    assert is_delete_operator == nil

    delete_operator_type(operator_type_info, conn)

    is_delete_type =
      select_all_operator_type(conn)
      |> Enum.find(&(get_in(&1, ["name"]) == "test_for_change_type"))

    assert  is_delete_type == nil
    assert {:ok, 1} == MsgGateway.RedisManager.del("test_for_change")
  end

  defp create_operator(operator_type_info, operator_name, conn) do
    post(conn, "/api/operators" ,
    %{"resource" => %{
      "name" =>operator_name,
      "operator_type_id" => get_in(operator_type_info, ["id"]),
      "protocol_name" => operator_name,
      "config" => %{},
      "price" => 18,
      "limit" => 1000,
      "active" => false
    }})
    |> json_response(200)
    |> get_in(["data", "status"])
  end

  defp create_operator_type(name, conn) do
    post(conn, "/api/operator_type" , %{"resource" => %{"operator_type_name" => name}})
    |> json_response(200)
    |> get_in(["data", "status"])
  end

  defp select_all_operator_type(conn) do
    get(conn, "/api/operator_type")
    |> json_response(200)
    |> get_in(["data"])
  end

  defp select_all_operator(conn) do
    get(conn, "/api/operators")
    |> json_response(200)
    |> get_in(["data"])
  end

  defp change_operator(operator_info, conn) do
    operator_info_ch = Map.put(operator_info, "limit", 20)
    post(conn, "/api/operators/change" , %{"resource" => operator_info_ch})
    |> json_response(200)
    |> get_in(["data", "status"])
  end

  defp delete_operator(operator_info, conn) do
    url_info = "/api/operators/" <> get_in(operator_info, ["id"])
    delete(conn, url_info)
  end

  defp delete_operator_type(operator_type_info, conn) do
    url_info = "/api/operator_type/" <> get_in(operator_type_info, ["id"])
    delete(conn, url_info)
  end
end
