defmodule MsgRouterTest do
  use ExUnit.Case
  doctest MsgRouter

  @sys_config %{
    automatic_prioritization: false,
    default_sms_operator: "",
    org_name: "test",
    sending_time: "60",
    sms_router_method: "send",
    sms_router_module: __MODULE__
  }

  @sys_config_automation_priority %{
    automatic_prioritization: true,
    default_sms_operator: "",
    org_name: "test",
    sending_time: "60",
    sms_router_method: "send",
    sms_router_module: __MODULE__
  }

  @smtp_protocol_config %{
    method_name: "send",
    module_name: __MODULE__
  }

  @smtp_protocol_name "smtp_protocol2"
  @sms_protocol_name "sms_protocol"

  @test_not_active_message %{
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
      protocol_name: "smtp_protocol2"
    }],
    sending_status: "delivered",
    subject: "new subject12345"
  }

  @test_no_active_protocol %{
    active: true,
    body: "12345mmm56565659",
    callback_url: "",
    contact: "test@skywerll.software",
    message_id: "a6ebd966-11a5-4f50-b89d-9fc00a3b8469",
    priority_list: [%{
      active: false,
      active_protocol_type: true,
      configs: %{host: "blabal"},
      limit: 1000,
      operator_priority: 1,
      priority: 1,
      protocol_name: "smtp_protocol2"
    }],
    sending_status: "sending",
    subject: "new subject12345"
  }

  @test_empty_priority_list %{
    active: true,
    body: "12345mmm56565659",
    callback_url: "",
    contact: "test@skywerll.software",
    message_id: "a6ebd966-11a5-4f50-b89d-9fc00a3b8468",
    priority_list: [],
    sending_status: "sending",
    subject: "new subject12345"
  }

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
      protocol_name: "smtp_protocol2"
    }],
    sending_status: "sending",
    subject: "new subject12345"
  }

  @test_sms_manual_priority %{
    active: true,
    body: "test",
    contact: "+380000000000",
    message_id: "a6ebd966-11a5-4f50-1111-9fc00a3b8469",
    priority_list: [%{
      active: true,
      active_protocol_type: true,
      configs: %{host: "blabal"},
      limit: 1000,
      operator_priority: 1,
      priority: 1,
      protocol_name: "sms_protocol"
    }],
    sending_status: "sending"
  }

  @test_automation_priority %{
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
      protocol_name: "smtp_protocol2"
    }],
    sending_status: "sending",
    subject: "new subject12345"
  }

  @sms_protocol %{
    active: true,
    active_protocol_type: true,
    code: "+38000",
    configs: %{host: "blabal"},
    limit: 1000,
    method_name: "send",
    module_name: __MODULE__,
    operator_priority: 1,
    priority: 1,
    protocol_name: "sms_protocol"
  }

  @sms_protocol_1 %{
    active: true,
    active_protocol_type: true,
    code: "+38067",
    limit: 1000,
    method_name: "first_sms_protocol",
    module_name: __MODULE__,
    operator_priority: 1,
    priority: 1,
    protocol_name: "first_sms_protocol",
    sms_price_for_external_operator: 10
  }

  @sms_protocol_2 %{
    active: true,
    active_protocol_type: true,
    code: "+38000",
    configs: %{sms_price_for_external_operator: 11},
    limit: 1000,
    method_name: "second_sms_protocol",
    module_name: __MODULE__,
    operator_priority: 1,
    priority: 1,
    protocol_name: "second_sms_protocol"
  }

  @sms_protocol_2_no_active %{
    active: false,
    active_protocol_type: true,
    code: "+38000",
    configs: %{sms_price_for_external_operator: 11},
    limit: 1000,
    method_name: "second_sms_protocol",
    module_name: __MODULE__,
    operator_priority: 1,
    priority: 1,
    protocol_name: "second_sms_protocol"
  }

  @test_sms_automation_priority_with_empty_lists %{
    active: true,
    body: "test",
    contact: "+380000000000",
    message_id: "a6ebd966-11a5-4f50-1111-9fc00a3b8469",
    priority_list: [@sms_protocol_1],
    sending_status: "sending"
  }

  @test_sms_automation_priority %{
    active: true,
    body: "test",
    contact: "+380000000000",
    message_id: "a6ebd966-11a5-4f50-1111-9fc00a3b8469",
    priority_list: [@sms_protocol],
    sending_status: "sending"
  }

  @test_sms_automation_priority_no_active %{
    active: true,
    body: "test",
    callback_url: "",
    contact: "+380000000000",
    message_id: "a6ebd966-11a5-4f50-1111-9fc00a3b8469",
    priority_list: [@sms_protocol_2_no_active],
    sending_status: "sending"
  }

  @operators_config [@sms_protocol_2]
  @operators_config_name "operators_config"
  @operators_config_no_active  [@sms_protocol_2_no_active]

  test "app start" do
    MsgRouter.Application.start(nil,nil)
  end

  test "send_message_manual_priority" do
    MsgRouter.RedisManager.set("system_config", @sys_config)
    MsgRouter.RedisManager.set(@smtp_protocol_name, @smtp_protocol_config)
    MsgRouter.RedisManager.set(Map.get(@test_manual_priority, :message_id), @test_manual_priority)

    assert :ok == MsgRouter.send_message(@test_manual_priority)

    MsgRouter.RedisManager.del(Map.get(@test_manual_priority, :message_id))

    assert {:ok, 1} == delete_from_redis("system_config")
    assert {:ok, 1} == delete_from_redis(@smtp_protocol_name)
  end

  test "send_message_as_sms_manual_priority" do
    MsgRouter.RedisManager.set("system_config", @sys_config)
    MsgRouter.RedisManager.set(Map.get(@test_sms_manual_priority, :message_id), @test_sms_manual_priority)
    MsgRouter.RedisManager.set(@sms_protocol_name, @smtp_protocol_config)

    assert :ok == MsgRouter.send_message(@test_sms_manual_priority)

    MsgRouter.RedisManager.del(Map.get(@test_sms_manual_priority, :message_id))

    assert {:ok, 1} == delete_from_redis("system_config")
    assert {:ok, 1} == delete_from_redis(@sms_protocol_name)
  end

  test "send_message_automation_priority" do
    MsgRouter.RedisManager.set("system_config", @sys_config_automation_priority)
    MsgRouter.RedisManager.set(Map.get(@test_automation_priority, :message_id), @test_automation_priority)
    MsgRouter.RedisManager.set(@smtp_protocol_name, @smtp_protocol_config)

    assert :ok == MsgRouter.send_message(@test_automation_priority)

    MsgRouter.RedisManager.del(Map.get(@test_automation_priority, :message_id))

    assert {:ok, 1} == delete_from_redis("system_config")
    assert {:ok, 1} == delete_from_redis(@smtp_protocol_name)
  end

  test "send_sms_automation_priority_with_empty_lists" do
    MsgRouter.RedisManager.set("system_config", @sys_config_automation_priority)
    MsgRouter.RedisManager.set(@operators_config_name, @operators_config)
    MsgRouter.RedisManager.set(Map.get(@sms_protocol_1, :protocol_name), @sms_protocol_1)
    MsgRouter.RedisManager.set(Map.get(@sms_protocol_2, :protocol_name), @sms_protocol_2)
    MsgRouter.RedisManager.set(Map.get(@test_sms_automation_priority_with_empty_lists, :message_id),
      @test_sms_automation_priority_with_empty_lists)

    assert :second_sms_protocol == MsgRouter.send_message(@test_sms_automation_priority_with_empty_lists)

    MsgRouter.RedisManager.del(Map.get(@test_sms_automation_priority_with_empty_lists, :message_id))

    assert {:ok, 1} == delete_from_redis("system_config")
    assert {:ok, 1} == delete_from_redis(@operators_config_name)
    assert {:ok, 1} == delete_from_redis(Map.get(@sms_protocol_1, :protocol_name))
    assert {:ok, 1} == delete_from_redis(Map.get(@sms_protocol_2, :protocol_name))
  end

  test "send_sms_automation_priority" do
    MsgRouter.RedisManager.set("system_config", @sys_config_automation_priority)
    MsgRouter.RedisManager.set(@operators_config_name, @operators_config)
    MsgRouter.RedisManager.set(Map.get(@sms_protocol, :protocol_name), @sms_protocol)
    MsgRouter.RedisManager.set(Map.get(@test_sms_automation_priority, :message_id), @test_sms_automation_priority)

    assert :ok == MsgRouter.send_message(@test_sms_automation_priority)

    MsgRouter.RedisManager.del(Map.get(@test_sms_automation_priority, :message_id))

    assert {:ok, 1} == delete_from_redis("system_config")
    assert {:ok, 1} == delete_from_redis(@operators_config_name)
    assert {:ok, 1} == delete_from_redis(Map.get(@sms_protocol, :protocol_name))
  end

  test "send_sms_automation_priority_no_active" do
    MsgRouter.RedisManager.set("system_config", @sys_config_automation_priority)
    MsgRouter.RedisManager.set(@operators_config_name, @operators_config_no_active)
    MsgRouter.RedisManager.set(Map.get(@sms_protocol_2_no_active, :protocol_name), @sms_protocol_2_no_active)
    MsgRouter.RedisManager.set(Map.get(@test_sms_automation_priority_no_active, :message_id), @test_sms_automation_priority_no_active)

    assert :ok == MsgRouter.send_message(@test_sms_automation_priority_no_active)

    MsgRouter.RedisManager.del(Map.get(@test_sms_automation_priority_no_active, :message_id))

    assert {:ok, 1} == delete_from_redis("system_config")
    assert {:ok, 1} == delete_from_redis(@operators_config_name)
    assert {:ok, 1} == delete_from_redis(Map.get(@sms_protocol_2_no_active, :protocol_name))
  end

  test "try_send_not_active_message" do
    MsgRouter.RedisManager.set(Map.get(@test_not_active_message, :message_id), @test_not_active_message)
    MsgRouter.send_message(@test_not_active_message)
    res = MsgRouter.RedisManager.get(Map.get(@test_not_active_message, :message_id))

    assert false == res.active

    MsgRouter.RedisManager.del(Map.get(@test_not_active_message, :message_id))
  end

  test "try_send_message_empty_priority_list" do
    MsgRouter.RedisManager.set(Map.get(@test_empty_priority_list, :message_id), @test_empty_priority_list)
    MsgRouter.send_message(@test_empty_priority_list)
    res =  MsgRouter.RedisManager.get(Map.get(@test_empty_priority_list, :message_id))

    assert false == res.active

    MsgRouter.RedisManager.del(Map.get(@test_empty_priority_list, :message_id))
  end

  test "try_send_message_to_no_active_protocol" do
    MsgRouter.RedisManager.set("system_config", @sys_config_automation_priority)
    MsgRouter.RedisManager.set(Map.get(@test_no_active_protocol, :message_id), @test_no_active_protocol)
    MsgRouter.send_message(@test_no_active_protocol)
    res =  MsgRouter.RedisManager.get(Map.get(@test_no_active_protocol, :message_id))

    assert false == res.active

    MsgRouter.RedisManager.del(Map.get(@test_no_active_protocol, :message_id))

    assert {:ok, 1} == delete_from_redis("system_config")
  end

  test "test_redis" do
    MsgRouter.Application.start(nil,nil)
    MsgRouter.RedisManager.set("test", "test")
    assert "test" = MsgRouter.RedisManager.get("test")
    MsgRouter.RedisManager.del("test")

    assert {:ok, 0} ==  MsgRouter.RedisManager.del("test")
    assert {:error, :not_found} = MsgRouter.RedisManager.get("test")
  end

  def send(_), do: :ok
  def first_sms_protocol(_), do: :first_sms_protocol
  def second_sms_protocol(_), do: :second_sms_protocol

  defp delete_from_redis(key) do
    MsgRouter.RedisManager.del(key)
  end
end
