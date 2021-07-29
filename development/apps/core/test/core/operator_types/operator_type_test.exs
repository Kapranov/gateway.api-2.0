defmodule Core.OperatorTypes.OperatorTypeTest do
  use Core.DataCase

  describe "operator_type" do
    alias Core.OperatorTypes
    alias Core.OperatorTypesRequests

    @valid_attrs %{
      active: true,
      name: "some text",
      priority: 22
    }

    @update_attrs %{
      active: false,
      name: "updated some text",
      priority: 99
    }

    @invalid_attrs %{ active: nil, name: nil, priority: nil }

    test "list_operator_types/0" do
      struct = insert(:operator_type)
      [data] = OperatorTypesRequests.list_operator_types()
      assert data.active   == struct.active
      assert data.name     == struct.name
      assert data.priority == struct.priority
    end

    test "add_operator_type/1" do
      assert {:ok, %OperatorTypes{} = struct} = OperatorTypesRequests.add_operator_type(@valid_attrs)
      assert struct.active   == true
      assert struct.name     == "some text"
      assert struct.priority == 1
    end

    test "add_operator_type/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = OperatorTypesRequests.add_operator_type(@invalid_attrs)
    end

    test "change_status/1" do
      struct = insert(:operator_type)
      attrs = %{id: struct.id, active: false}
      assert {1, nil} = OperatorTypesRequests.change_status(attrs)
      [changed_status] = OperatorTypesRequests.list_operator_types()
      assert changed_status.id       == struct.id
      assert changed_status.active   == false
      assert changed_status.name     == struct.name
      assert changed_status.priority == struct.priority
    end

    test "get_by_name/0" do
      struct = insert(:operator_type)
      assert get_by_named = OperatorTypesRequests.get_by_name(struct.name)
      assert struct.id       == get_by_named.id
      assert struct.active   == get_by_named.active
      assert struct.name     == get_by_named.name
      assert struct.priority == get_by_named.priority
    end

    test "delete/1" do
      struct = insert(:operator_type)
      assert {1, nil} = OperatorTypesRequests.delete(struct.id)
    end

    test "update_priority/1" do
      struct = insert(:operator_type)
      attrs = [%{
        "id" => struct.id,
        "priority" => Map.get(@update_attrs, :priority),
        "name" => Map.get(@update_attrs, :name),
        "active" => Map.get(@update_attrs, :active)
      }]
      assert {:ok, %Postgrex.Result{
        columns: nil,
        command: :update,
        connection_id: _,
        messages: [],
        num_rows: 1,
        rows: nil
      }} = OperatorTypesRequests.update_priority(attrs)
    end
  end
end
