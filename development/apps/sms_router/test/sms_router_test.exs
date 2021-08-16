defmodule SmsRouterTest do
  use ExUnit.Case
  use Core.DataCase

  alias SmsRouter.RedisManager

  doctest SmsRouter

  @sys_config %{
    automatic_prioritization: false,
    default_sms_operator: "",
    messages_router_method: "send",
    messages_router_module: __MODULE__,
    org_name: "test",
    sending_time: "60"
  }

  @sms_protocol_1 %{
    active: true,
    active_protocol_type: true,
    configs: %{
      code: "+38067",
      sms_price_for_external_operator: 11
    },
    id: nil,
    limit: 1000,
    method_name: "first_sms_protocol",
    module_name: __MODULE__,
    operator_priority: 1,
    priority: 1,
    protocol_name: "first_sms_protocol"
  }

  @sms_protocol_2 %{
    active: true,
    active_protocol_type: true,
    configs: %{
      code: "+38000",
      sms_price_for_external_operator: 11
    },
    id: nil,
    limit: 1000,
    method_name: "second_sms_protocol",
    module_name: __MODULE__,
    operator_priority: 1,
    priority: 1,
    protocol_name: "second_sms_protocol"
  }

  @sms_info %{
    active: true,
    body: "test",
    contact: "+380000000000",
    message_id: "a6ebd966-11a5-4f50-1111-9fc00a3b8469",
    priority_list: [@sms_protocol_1, @sms_protocol_2],
    sending_status: "sending"
  }

  @operators_config [@sms_protocol_1, @sms_protocol_2]

  test "app start" do
    SmsRouter.Application.start(nil,nil)
  end

  test "sms_router" do
    message_id = "test_id678"
    RedisManager.set("system_config", @sys_config)
    RedisManager.set(message_id, %{
      active: true,
      body: "test message",
      callback_url: "",
      contact: "+380500000000",
      message_id: message_id,
      priority_list: [],
      sending_status: "in_queue"
    })

    assert :ok == SmsRouter.check_and_send(%{contact: "+380500000000", body: "test message", message_id: message_id})
    assert {:ok, 1} == RedisManager.del("system_config")

    RedisManager.keys("system_config")
    RedisManager.del("system_config1")

    assert {:ok, 1} == RedisManager.del(message_id)
  end

  test "select operators sms_router" do
    RedisManager.set("system_config", @sys_config)
    RedisManager.set(get_in(@sms_protocol_1, [:protocol_name]), @sms_protocol_1)
    RedisManager.set(get_in(@sms_protocol_2, [:protocol_name]), @sms_protocol_2)
    RedisManager.set("operators_config", @operators_config)
    RedisManager.set(get_in(@sms_info, [:message_id]), @sms_info)

    assert :second_sms_protocol == SmsRouter.check_and_send(@sms_info)
    assert {:ok, 1} == RedisManager.del("system_config")
    assert {:ok, 1} == RedisManager.del("operators_config")
    assert {:ok, 1} == RedisManager.del(get_in(@sms_protocol_1, [:protocol_name]))
    assert {:ok, 1} == RedisManager.del(get_in(@sms_protocol_2, [:protocol_name]))
    assert {:ok, 1} == RedisManager.del(get_in(@sms_info, [:message_id]))
  end

  def send(_), do: :ok
  def first_sms_protocol(_), do: :first_sms_protocol
  def second_sms_protocol(_), do: :second_sms_protocol
end
