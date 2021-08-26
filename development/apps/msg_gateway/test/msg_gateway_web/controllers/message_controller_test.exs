defmodule MsgGatewayWeb.MessageControllerTest do
  use MsgGatewayWeb.ConnCase
  use Core.DataCase

  test "create /message", %{conn: conn} do
    response = create_message(conn, 200, ["data"])
    assert get_in(response, ["body"])    == nil
    assert get_in(response, ["contact"]) == nil
    assert get_in(response, ["tag"])     == "111111111"
  end

  test "show /message/:id", %{conn: conn} do
    created = create_message(conn, 200, ["data"])
    message_id = get_in(created, ["message_id"])
    response = show_message(conn, 200, message_id, ["data"])
    assert get_in(response, ["message_id"])     ==  created["message_id"]
    assert get_in(response, ["message_status"]) == "in_queue"
  end

  test "show /message/:id when not correct id", %{conn: conn} do
    message_id = FlakeId.get()
    response = show_message(conn, 200, message_id, ["data"])
    assert get_in(response, ["message_id"])     == message_id
    assert get_in(response, ["message_status"]) == "not_found"
  end

  test "change_message_status /sending/change_message_status", %{conn: conn} do
    assert create_key(conn) == "success"
    [key_couple | _] = select_all_keys(conn)
    key = Base.hex_encode32(:crypto.hash(:sha256, get_in(key_couple, ["key"])), case: :lower)
    new_conn = add_auth_header(get_in(key_couple, ["id"]), key, conn)
    response = send_message(new_conn, 200, ["data"])
    assert get_in(response, ["tag"]) == "111111111"
    assert check_status(get_in(response, ["message_id"]), new_conn) == "in_queue"

    assert change_message_status(get_in(response, ["message_id"]), new_conn) == "Status of sending was successfully changed"

    assert check_status(get_in(response, ["message_id"]), new_conn) == "success"

    remove_key(get_in(key_couple, ["id"]), conn)
  end

  test "new_email /sending/email", %{conn: conn} do
    assert create_key(conn) == "success"
    [key_couple | _] = select_all_keys(conn)
    key = Base.hex_encode32(:crypto.hash(:sha256, get_in(key_couple, ["key"])), case: :lower)
    new_conn = add_auth_header(get_in(key_couple, ["id"]), key, conn)
    response = send_email(new_conn)
    assert get_in(response, ["tag"]) == "111111111"
    assert check_status(get_in(response, ["message_id"]), new_conn) == "in_queue"
    remove_key(get_in(key_couple, ["id"]), conn)
  end

  defp create_message(conn, resp_status, attrs) do
    post(conn, "/message", %{"resource" => %{
      "body" => "Ваш код для підтвердження 451",
      "contact" => "+3800000000000",
      "tag" => "111111111"
    }})
    |> json_response(resp_status)
    |> get_in(attrs)
  end

  defp show_message(conn, resp_status, message_id, attrs) do
    get(conn, "/message/#{message_id}")
    |> json_response(resp_status)
    |> get_in(attrs)
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

  defp add_auth_header(id, key, conn) do
    put_req_header(conn, "authorization", "Bearer "<> id <> ":" <> key)
  end

  defp send_message(conn, resp_status, keys) do
    post(conn, "/message", %{"resource" => %{
      "tag" => "111111111",
      "contact" => "+3800000000000",
      "body" => "Ваш код для підтвердження 451"
    }})
    |> json_response(resp_status)
    |> get_in(keys)
  end

  defp check_status(message_id, conn) do
    get(conn, "/message/#{message_id}")
    |> json_response(200)
    |> get_in(["data", "message_status"])
  end

  defp change_message_status(message_id, conn) do
    post(conn, "/sending/change_message_status", %{"resource" =>
    %{"message_id" => message_id, "sending_active" => "success"}})
    |> json_response(200)
    |> get_in(["data", "message"])
  end

  defp remove_key(id, conn) do
    delete(conn, "/api/keys/" <> id)
    |> json_response(200)
    |> get_in(["data", "status"])
  end

  defp send_email(conn) do
    post(conn, "/sending/email", %{"resource" => %{
      "tag" => "111111111",
      "email" => "test@u.u",
      "subject" => "subject",
      "body" => "Ваш код для підтвердження 451"
    }})
    |> json_response(200)
    |> get_in(["data"])
  end
end

defmodule MqManagerTest, do: def publish(_), do: :ok
