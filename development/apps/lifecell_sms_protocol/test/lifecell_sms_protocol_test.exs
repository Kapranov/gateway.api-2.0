defmodule LifecellSmsProtocolTest do
  use ExUnit.Case
  doctest LifecellSmsProtocol

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

  @lifecell_sms_protocol_config %{module_name: @name, method_name: "send"}

  @lifecell_sms_protocol_name "lifecell_sms_protocol"

  @test_manual_priority %{
    active: true,
    body: "12345mmm56565659",
    callback_url: "",
    contact: "test@skywerll.software",
    message_id: "a6ebd966-11a5-4f50-b89d-9fc00a3b8469",
    priority_list: [%{
      active: true,
      active_protocol_type: true,
      configs: %{host: "blabal"},
      limit: 1000,
      operator_priority: 1,
      priority: 1,
      protocol_name: "lifecell_sms_protocol"
    }],
    sending_status: "sending"
  }

  test "app start" do
    LifecellSmsProtocol.Application.start(nil,nil)
    LifecellSmsProtocol.start_link()
    LifecellSmsProtocol.init(nil)
  end

  test "test_redis" do
    LifecellSmsProtocol.RedisManager.set("test", "test")

    assert "test" = LifecellSmsProtocol.RedisManager.get("test")

    LifecellSmsProtocol.RedisManager.del("test")

    assert {:ok, 0} ==  LifecellSmsProtocol.RedisManager.del("test")
    assert {:error, :not_found} = LifecellSmsProtocol.RedisManager.get("test")
  end

  test "message test" do
    LifecellSmsProtocol.RedisManager.set(@messages_gateway_conf, @sys_config)
    LifecellSmsProtocol.RedisManager.set(@lifecell_sms_protocol_name, @lifecell_sms_protocol_config)

    id = Map.get(@test_manual_priority, :message_id)

    LifecellSmsProtocol.RedisManager.set(id, @test_manual_priority)

    assert :ok ==  LifecellSmsProtocol.send_message(%{
      body: Map.get(@test_manual_priority, :body),
      contact: Map.get(@test_manual_priority, :contact),
      message_id: id
    })

    :timer.sleep(12000)

    LifecellSmsProtocol.RedisManager.del(id)
    LifecellSmsProtocol.RedisManager.del(@messages_gateway_conf)
  end

  def send(_value), do: :ok
end
