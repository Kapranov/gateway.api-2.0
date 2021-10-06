defmodule MsgGatewayWeb.PatternNotificationControllerTest do
  use MsgGatewayWeb.ConnCase
  use Core.DataCase

  test "create /notification/template", %{conn: conn} do
    response = create_pattern_notification(conn, 200, ["data"])
    assert get_in(response, ["status"])   == "success"
  end

  defp create_pattern_notification(conn, resp_status, attrs) do
    post(conn, "/api/v1/notification/template", %{"resource" => %{
      "action_type" => "some text",
      "full_text" => "some text",
      "template_type" => "some text",
      "title" => "some text"
    }})
    |> json_response(resp_status)
    |> get_in(attrs)
  end
end
