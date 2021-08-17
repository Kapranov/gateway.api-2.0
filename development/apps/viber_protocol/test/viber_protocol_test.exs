defmodule ViberProtocolTest do
  use ExUnit.Case
  doctest ViberProtocol
  use Core.DataCase

  @name __MODULE__

  @sys_config %{
    automatic_prioritization: false,
    default_sms_operator: "",
    org_name: "test",
    sending_time: "60",
    sms_router_method: "send",
    sms_router_module: @name
  }

  @messages_gateway_conf "system_config"

  @viber_protocol_config %{
    method_name: "send",
    module_name: @name
  }

  @viber_protocol_name "viber_protocol"

  @test_manual_priority %{
    active: true,
    body: "12345mmm56565659",
    callback_url: "",
    contact: "test123",
    message_id: "a6ebd966-11a5-4f50-b89d-9fc00a3b8469",
    priority_list: [%{
      active: true,
      active_protocol_type: true,
      configs: %{host: "blabal"},
      limit: 1000,
      operator_priority: 1,
      priority: 1,
      protocol_name: "viber_protocol"
    }],
    sending_status: "sending"
  }

  test "app start" do
    ViberProtocol.Application.start(nil,nil)
    ViberProtocol.start_link()
    ViberProtocol.init(nil)
  end

  test "test_redis" do
    ViberProtocol.RedisManager.set("test", "test")

    assert "test" = ViberProtocol.RedisManager.get("test")

    ViberProtocol.RedisManager.del("test")

    assert {:ok, 0} ==  ViberProtocol.RedisManager.del("test")
    assert {:error, :not_found} = ViberProtocol.RedisManager.get("test")
  end

  test "message test" do
    ViberProtocol.RedisManager.set(@messages_gateway_conf, @sys_config)
    ViberProtocol.RedisManager.set(@viber_protocol_name, @viber_protocol_config)

    id = Map.get(@test_manual_priority, :message_id)

    ViberProtocol.RedisManager.set(id, @test_manual_priority)
    ViberProtocol.send_message(%{contact: Map.get(@test_manual_priority, :contact), message_id: id})
    ViberProtocol.set_webhook("1234")
    ViberProtocol.check_and_send_message(%{viber_id: "ok"}, %{body: "body", message_id: id})
    ViberProtocol.callback_response(%{body_params: %{"event" => "seen", "message_token" => "123d"}})
    ViberProtocol.callback_response(%{body_params: %{"event" => "conversation_started", "message_token" => "123d"}})
    ViberProtocol.callback_response(%{body_params: %{"event" => "subscribed", "message_token" => "123d"}})
    ViberProtocol.callback_response(%{body_params: %{"event" => "message", "message_token" => "123d"}})
    ViberProtocol.end_sending_message(:success, id)
    :timer.sleep(12000)
    ViberProtocol.RedisManager.del(id)
    ViberProtocol.RedisManager.del(@messages_gateway_conf)
    ViberProtocol.RedisManager.del(@viber_protocol_name)
  end

  def send(_value), do: :ok
end
