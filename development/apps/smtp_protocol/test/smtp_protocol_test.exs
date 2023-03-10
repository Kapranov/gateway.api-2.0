defmodule SmtpProtocolTest do
  use ExUnit.Case
  doctest SmtpProtocol

  @name __MODULE__
  @smtp_protocol_config  %{
    method_name: "send",
    module_name: @name
  }

  @smtp_protocol_name "smtp_protocol"

  @test_manual_priority %{
    active: true,
    body: "12345mmm56565659", callback_url: "",
    contact: "test123",
    message_id: "a6ebd966-11a5-4f40-b89d-9fc00a3b8469",
    priority_list: [ %{
      active: true,
      active_protocol_type: true,
      configs: %{host: "blabal"},
      limit: 1000,
      operator_priority: 1,
      priority: 1,
      protocol_name: "smtp_protocol"
    }],
    sending_status: "sending",
    subject: "test subj12"
  }

  test "email test" do
    SmtpProtocol.RedisManager.set(@smtp_protocol_name, @smtp_protocol_config)
    id = Map.get(@test_manual_priority, :message_id)
    SmtpProtocol.RedisManager.set(id, @test_manual_priority)
    SmtpProtocol.send_email(@test_manual_priority)
    SmtpProtocol.RedisManager.del(id)
    SmtpProtocol.RedisManager.del(@smtp_protocol_name)
  end

  test "app start" do
    SmtpProtocol.Application.start(nil,nil)
    SmtpProtocol.start_link()
    SmtpProtocol.init(nil)
  end

  test "test_redis" do
    SmtpProtocol.RedisManager.set("test", "test")
    assert "test" = SmtpProtocol.RedisManager.get("test")
    SmtpProtocol.RedisManager.del("test")

    assert {:ok, 0} ==  SmtpProtocol.RedisManager.del("test")
    assert {:error, :not_found} = SmtpProtocol.RedisManager.get("test")
  end

  def send(_value), do: :ok
end
