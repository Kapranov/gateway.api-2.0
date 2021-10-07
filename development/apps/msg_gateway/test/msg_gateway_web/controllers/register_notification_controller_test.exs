defmodule MsgGatewayWeb.RegisterNotificationControllerTest do
  use MsgGatewayWeb.ConnCase
  use Core.DataCase

  @resource_id FlakeId.get()

  test "index /notification/distribution/push", %{conn: conn} do
    assert create_pattern_notification(conn, 200, ["data"]) == "success"
    [struct] = index_pattern_notification(conn, 200)
    assert struct != nil
    response = create_register_notification(conn, 200, struct["id"], ["data"])
    assert get_in(response, ["status"]) == "success"
    [data] = index_register_notification(conn, 200)
    assert data["id"]                                =~ ""
    assert data["inserted_at"]                       =~ "2021-10"
    assert data["pattern_notification_id"]           =~ ""
    assert data["recipients"]["parameters"]["key"]   == "some text"
    assert data["recipients"]["parameters"]["value"] == "some text"
    assert data["recipients"]["resource_id"]         =~ ""
    assert data["recipients"]["rnokpp"]              == "some text"
    assert data["updated_at"]                        =~ "2021-10"
  end

  test "create /notification/distribution/push", %{conn: conn} do
    assert create_pattern_notification(conn, 200, ["data"]) == "success"
    [struct] = index_pattern_notification(conn, 200)
    assert struct != nil
    response = create_register_notification(conn, 200, struct["id"], ["data"])
    assert get_in(response, ["status"]) == "success"
  end

  test "show /notification/distribution/push/:id", %{conn: conn} do
    assert create_pattern_notification(conn, 200, ["data"]) == "success"
    [pattern_notification] = index_pattern_notification(conn, 200)
    assert pattern_notification != nil
    response = create_register_notification(conn, 200, pattern_notification["id"], ["data"])
    assert get_in(response, ["status"]) == "success"
    [data] = index_register_notification(conn, 200)
    struct = show_register_notification(conn, 200, data["id"], ["data"])
    assert struct["id"]                                =~ ""
    assert struct["inserted_at"]                       =~ "2021-10"
    assert struct["pattern_notification_id"]           =~ ""
    assert struct["recipients"]["parameters"]["key"]   == "some text"
    assert struct["recipients"]["parameters"]["value"] == "some text"
    assert struct["recipients"]["resource_id"]         =~ ""
    assert struct["recipients"]["rnokpp"]              == "some text"
    assert struct["updated_at"]                        =~ "2021-10"
  end

  test "delete /notification/distribution/push/:id", %{conn: conn} do
    assert create_pattern_notification(conn, 200, ["data"]) == "success"
    [pattern_notification] = index_pattern_notification(conn, 200)
    assert pattern_notification != nil
    response = create_register_notification(conn, 200, pattern_notification["id"], ["data"])
    assert get_in(response, ["status"]) == "success"
    [data] = index_register_notification(conn, 200)
    response = delete_register_notification(conn, 200, data["id"])
    assert get_in(response, ["status"]) == "success"
  end

  defp index_pattern_notification(conn, resp_status) do
    get(conn, "/api/v1/notification/template")
    |> json_response(resp_status)
    |> get_in(["data"])
  end

  defp index_register_notification(conn, resp_status) do
    get(conn, "/api/v1/notification/distribution/push")
    |> json_response(resp_status)
    |> get_in(["data"])
  end

  defp create_pattern_notification(conn, resp_status, _attrs) do
    post(conn, "/api/v1/notification/template", %{"resource" => %{
      "action_type" => "some text",
      "full_text" => "some text",
      "need_auth" => true,
      "remove_previous" => true,
      "short_text" => "some text",
      "template_type" => "some text",
      "time_to_live_in_sec" => 123456789,
      "title" => "some text"
    }})
    |> json_response(resp_status)
    |> get_in(["data", "status"]) 
  end

  defp create_register_notification(conn, resp_status, id, _attrs) do
    post(conn, "/api/v1/notification/distribution/push", %{"resource" => %{
      "pattern_notification_id" => id,
      "recipients" => %{
         "parameters" => %{
            "key" => "some text",
            "value" => "some text"
         },
         "resource_id" => @resource_id,
         "rnokpp" => "some text"
      }
    }})
    |> json_response(resp_status)
    |> get_in(["data"]) 
  end

  defp show_register_notification(conn, resp_status, id, attrs) do
    get(conn, "/api/v1/notification/distribution/push/#{id}")
    |> json_response(resp_status)
    |> get_in(attrs)
  end

  defp delete_register_notification(conn, resp_status, id) do
    delete(conn, "/api/v1/notification/distribution/push/" <> id)
    |> json_response(resp_status)
    |> get_in(["data"]) 
  end
end
