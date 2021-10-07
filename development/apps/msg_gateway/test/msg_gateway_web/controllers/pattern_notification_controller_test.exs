defmodule MsgGatewayWeb.PatternNotificationControllerTest do
  use MsgGatewayWeb.ConnCase
  use Core.DataCase

  test "index /notification/template", %{conn: conn} do
    response = create_pattern_notification(conn, 200, ["data"])
    assert get_in(response, ["status"])   == "success"

    [struct] = index_pattern_notification(conn, 200)

    assert struct["action_type"]         == "some text"
    assert struct["full_text"]           == "some text"
    assert struct["id"]                  =~ ""
    assert struct["inserted_at"]         =~ "2021-10"
    assert struct["need_auth"]           == true
    assert struct["remove_previous"]     == true
    assert struct["short_text"]          == "some text"
    assert struct["template_type"]       == "some text"
    assert struct["time_to_live_in_sec"] == 123456789
    assert struct["title"]               == "some text"
    assert struct["updated_at"]          =~ "2021-10"
  end

  test "create /notification/template", %{conn: conn} do
    response = create_pattern_notification(conn, 200, ["data"])
    assert get_in(response, ["status"])   == "success"
  end

  defp index_pattern_notification(conn, resp_status) do
    get(conn, "/api/v1/notification/template")
    |> json_response(resp_status)
    |> get_in(["data"])
  end

  defp create_pattern_notification(conn, resp_status, attrs) do
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
    |> get_in(attrs)
  end
end
