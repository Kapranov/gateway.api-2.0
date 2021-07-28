defmodule Core.OperatorTypes.OperatorTypeTest do
  use Core.DataCase

  describe "operator_type" do
    alias Core.OperatorTypes

    @valid_attrs %{
      name: "some text",
      active: true,
      priority: 22
    }

    @update_attrs %{
      name: "updated some text",
      active: false,
      priority: 99
    }

    @invalid_attrs %{ active: nil, name: nil, priority: nil }

    test "list_operator_types/0 returns all OperatorTypes" do
      struct = insert(:operator_type)
      struct.name     == "some text"
      struct.active   == true
      struct.priority == 22
    end
  end
end
