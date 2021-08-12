defmodule MsgGatewayWeb.KeysControllerTest do
  use MsgGatewayWeb.ConnCase

  test "create auth key", %{conn: conn} do
    assert create_key(conn) == "success"

    keys = select_all_keys(conn)

    assert length(keys) > 0
  end

  test "select keys", %{conn: conn} do
    assert create_key(conn) == "success"

    keys = select_all_keys(conn)

    assert length(keys) > 0
  end

  test "activate and deactivate key", %{conn: conn} do
    assert create_key(conn) == "success"

    keys = select_all_keys(conn)

    assert length(keys) > 0

    [key | _] = keys

    assert get_in(key, ["active"]) == true

    deactivate_key(get_in(key, ["id"]), conn)
    updated_key =
      select_all_keys(conn)
      |> Enum.find(&(get_in(key, ["id"]) == get_in(&1, ["id"])))

    assert get_in(updated_key, ["active"]) == false

    activate_key(get_in(updated_key, ["id"]), conn)
    activated_key =
      select_all_keys(conn)
      |> Enum.find(&(get_in(updated_key, ["id"]) == get_in(&1, ["id"])))

    assert get_in(activated_key, ["active"]) == true
  end

  test "remove all keys", %{conn: conn} do
    select_all_keys(conn)
    |> Enum.map(&(assert remove_key( get_in(&1, ["id"]), conn) == "success"))
  end

  defp create_key(conn) do
    get(conn, "/api/keys")
    |> json_response(200)
    |> get_in(["data", "status"])
  end

  defp select_all_keys(conn) do
    get(conn, "/api/keys/all")
    |> json_response(200)
    |> get_in(["data", "keys"])
  end

  defp activate_key(id, conn) do
    post(conn, "/api/keys/activate", %{"resource" => %{"id" => id}})
    |> json_response(200)
    |> get_in(["data", "keys"])
  end

  defp deactivate_key(id, conn) do
    post(conn, "/api/keys/deactivate", %{"resource" => %{"id" => id}})
    |> json_response(200)
    |> get_in(["data", "keys"])
  end

  defp remove_key(id, conn) do
    delete(conn, "/api/keys/" <> id)
    |> json_response(200)
    |> get_in(["data", "status"])
  end
end
