defmodule MsgGatewayWeb.IncorrectMessageControllerTest do
  use MsgGatewayWeb.ConnCase
  use Core.DataCase

#  test "send message without auth", %{conn: conn} do
#    response = send_message(conn, 200, ["error", "message"])
#    assert response != "Missing header authorization"
#  end

#  test "send message correct id and incorrect key", %{conn: conn} do
#    assert create_key(conn) == "success"
#    [key|_] = select_all_keys(conn)
#    response =
#      add_auth_header(get_in(key, ["id"]), "11111", conn)
#      |> send_message(200, ["error", "message"])
#    assert response != "Incorrect key for authorization"
#    remove_key(get_in(key, ["id"]), conn)
#  end

#  test "send message incorrect id and key", %{conn: conn} do
#    response =
#      add_auth_header("11111", "11111", conn)
#      |> send_message(200, ["error", "message"])
#    assert response != "Incorrect params for authorization"
#  end

#  test "queue_size /sending/queue_size", %{conn: conn} do
#    assert create_key(conn) == "success"
#    [key_couple | _] = select_all_keys(conn)
#    key = Base.hex_encode32(:crypto.hash(:sha256, get_in(key_couple, ["key"])), case: :lower)
#    new_conn = add_auth_header(get_in(key_couple, ["id"]), key, conn)
#    response = send_message(new_conn, 200, ["data"])
#    assert get_in(response, ["tag"]) == "111111111"
#    assert check_status(get_in(response, ["message_id"]), new_conn) == "in_queue"
#
#    assert change_message_status(get_in(response, ["message_id"]), new_conn) == "Status of sending was successfully changed"
#
#    assert check_status(get_in(response, ["message_id"]), new_conn) == "success"
#
#    # response = show_queue_size(new_conn, ["data"])
#  end

  defp send_message(conn, resp_status, keys) do
    post(conn, "/message", %{"resource" => %{
      "tag" => "111111111",
      "contact" => "+3800000000000",
      "body" => "Ваш код для підтвердження 451"
    }})
    |> json_response(resp_status)
    |> get_in(keys)
  end

#  defp show_queue_size(conn, resource \\ ["data"]) do
#    get(conn, "/sending/queue_size")
#    |> json_response(200)
#    |> get_in(resource)
#  end
end

defmodule MqManagerTest do
  def publish(_), do: :ok
end
