defmodule MessagesGatewayInitTest do
  use ExUnit.Case
  use Core.DataCase

  test "app test" do
    MsgGatewayInit.start_link()
    MsgGatewayInit.init(nil)
    MsgGateway.Application.start(nil,nil)
  end
end
