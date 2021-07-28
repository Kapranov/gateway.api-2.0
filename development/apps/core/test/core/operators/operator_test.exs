defmodule Core.Operators.OperatorTest do
  use Core.DataCase

  describe "operator" do
    alias Core.Operators

    @valid_attrs %{
      active: true,
      config: Map.new,
      limit: 22,
      name: "some text",
      price: 22,
      priority: 22,
      protocol_name: "some text"
    }

    @update_attrs %{
      active: false,
      config: Map.new,
      limit: 99,
      name: "updated some text",
      price: 99,
      priority: 99,
      protocol_name: "updated some text"
    }

    @invalid_attrs %{
      active: nil,
      config: nil,
      limit: nil,
      name: nil,
      operator_type_id: nil,
      price: nil,
      priority: nil,
      protocol_name: nil
    }

    test "list_operators/0 returns all Operators" do
      operator_type = insert(:operator_type)
      struct = insert(:operator, operator_types: operator_type)
      struct.active           == true
      struct.config           == Map.new
      struct.limit            == 22
      struct.name             == "some text"
      struct.operator_type_id == operator_type.id
      struct.price            == 22
      struct.priority         == 22
      struct.protocol_name    == "some text"
    end
  end
end
