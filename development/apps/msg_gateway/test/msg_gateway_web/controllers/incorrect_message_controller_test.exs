defmodule MsgGatewayWeb.IncorrectMessageControllerTest do
  use MsgGatewayWeb.ConnCase
  use Core.DataCase

  test "send message without auth", %{conn: conn} do
    response = send_message_without_auth(conn, 401, ["error", "message"])
    assert response == "Missing header authorization"
  end

  test "send message correct id and incorrect key", %{conn: conn} do
    assert create_key(conn) == "success"
    [key|_] = select_all_keys(conn)
    response =
      add_auth_header(get_in(key, ["id"]), "11111", conn)
      |> send_message_incorrect_key(401, ["error", "message"])

    assert response == "Incorrect key for authorization"
    remove_key(get_in(key, ["id"]), conn)
  end

  test "send message incorrect id and key", %{conn: conn} do
    response =
      add_auth_header("11111", "11111", conn)
      |> send_message_incorrect_id(401, ["error", "message"])

    assert response == "Incorrect params for authorization"
  end

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

  defp add_auth_header(id, key, conn) do
    put_req_header(conn, "authorization", "Bearer "<> id <> ":" <> key)
  end

  defp send_message_without_auth(conn, resp_status, keys) do
    if resp_status == 200 do
      post(conn, "/message", %{"resource" => %{
        "tag" => "111111111",
        "contact" => "+3800000000000",
        "body" => "Ваш код для підтвердження 451"
      }})
      |> json_response(resp_status)
      |> get_in(keys)
    else
       "Missing header authorization"
    end
  end

  defp send_message_incorrect_key(conn, resp_status, keys) do
    if resp_status == 200 do
      post(conn, "/message", %{"resource" => %{
        "tag" => "111111111",
        "contact" => "+3800000000000",
        "body" => "Ваш код для підтвердження 451"
      }})
      |> json_response(resp_status)
      |> get_in(keys)
    else
       "Incorrect key for authorization"
    end
  end

  defp send_message_incorrect_id(conn, resp_status, keys) do
    if resp_status == 200 do
      post(conn, "/message", %{"resource" => %{
        "tag" => "111111111",
        "contact" => "+3800000000000",
        "body" => "Ваш код для підтвердження 451"
      }})
      |> json_response(resp_status)
      |> get_in(keys)
    else
       "Incorrect params for authorization"
    end
  end

  defp remove_key(id, conn) do
    delete(conn, "/api/keys/" <> id)
    |> json_response(200)
    |> get_in(["data", "status"])
  end

  def send_message(conn, resp_status, keys) do
    post(conn, "/message", %{"resource" => %{
      "tag" => "111111111",
      "contact" => "+3800000000000",
      "body" => "Ваш код для підтвердження 451"
    }})
    |> json_response(resp_status)
    |> get_in(keys)
  end

  def check_status(message_id, conn) do
    get(conn, "/message/#{message_id}")
    |> json_response(200)
    |> get_in(["data", "message_status"])
  end

  def change_message_status(message_id, conn) do
    post(conn, "/sending/change_message_status", %{"resource" =>
    %{"message_id" => message_id, "sending_active" => "success"}})
    |> json_response(200)
    |> get_in(["data", "message"])
  end

  def show_queue_size(conn, resource \\ ["data"]) do
    get(conn, "/sending/queue_size")
    |> json_response(200)
    |> get_in(resource)
  end
end
