defmodule Core.OperatorTypes.OperatorTypeTest do
  use Core.DataCase

  describe "operator_type" do
    alias Core.{OperatorTypes, OperatorTypesRequests}

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

    test "list_operator_types/0 when list is empty" do
      data = OperatorTypesRequests.list_operator_types()
      assert data             == []
      assert Enum.count(data) == 0
    end

    test "add_operator_type/1" do
      assert {:ok, %OperatorTypes{} = struct} = OperatorTypesRequests.add_operator_type(@valid_attrs)
      assert struct.active   == true
      assert struct.name     == "some text"
      assert struct.priority == 1
    end

    test "add_operator_type/1 when attrs is not correct" do
      attrs = %{active: nil, name: nil, priority: nil}
      assert {:error, %Ecto.Changeset{}} = OperatorTypesRequests.add_operator_type(attrs)
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

    test "FAULT change_status/1 when id is not correct" do
#      struct = insert(:operator_type)
#      attrs = %{id: FlakeId.get, active: false}
#      assert {0, nil} = OperatorTypesRequests.change_status(attrs)
    end

    test "FAULT change_status/1 when active is nil" do
#      struct = insert(:operator_type)
#      attrs = %{id: struct.id, active: nil}
#      assert {1, nil} = OperatorTypesRequests.change_status(attrs)
#      [changed_status] = OperatorTypesRequests.list_operator_types()
#      assert changed_status.id       == struct.id
#      assert changed_status.active   == false
#      assert changed_status.name     == struct.name
#      assert changed_status.priority == struct.priority
    end

    test "get_by_name/0" do
      struct = insert(:operator_type)
      assert get_by_named = OperatorTypesRequests.get_by_name(struct.name)
      assert struct.id       == get_by_named.id
      assert struct.active   == get_by_named.active
      assert struct.name     == get_by_named.name
      assert struct.priority == get_by_named.priority
    end

    test "FAULT get_by_name/0 when name is nil" do
      struct = insert(:operator_type)
      assert get_by_named = OperatorTypesRequests.get_by_name(struct.name)
      assert struct.id       == get_by_named.id
      assert struct.active   == get_by_named.active
      assert struct.name     == get_by_named.name
      assert struct.priority == get_by_named.priority
    end

    test "FAULT get_by_name/0 when name is not exist" do
#      insert(:operator_type)
#      assert get_by_named = OperatorTypesRequests.get_by_name("xxx")
    end

    test "delete/1" do
      struct = insert(:operator_type)
      assert {1, nil} = OperatorTypesRequests.delete(struct.id)
    end

    test "FAULT delete/1 when id is nil" do
#      insert(:operator_type)
#      assert {0, nil} = OperatorTypesRequests.delete(nil)
    end

    test "delete/1 when id is not exist" do
#      insert(:operator_type)
#      id = FlakeId.get()
#      assert {0, nil} = OperatorTypesRequests.delete(id)
    end

    test "update_priority/1" do
      struct = insert(:operator_type)
      attrs = [%{
        "id" => struct.id,
        "active" => Map.get(@update_attrs, :active),
        "name" => Map.get(@update_attrs, :name),
        "priority" => Map.get(@update_attrs, :priority)
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

    test "FAULT update_priority/1 when id is nil" do
      insert(:operator_type)
      id = nil
      attrs = [%{
        "id" => id,
        "active" => Map.get(@update_attrs, :active),
        "name" => Map.get(@update_attrs, :name),
        "priority" => Map.get(@update_attrs, :priority)
      }]
      assert {:error, %Postgrex.Error{
        connection_id: _,
        __exception__: true,
        message: nil,
        postgres: _,
        query: _
      }} = OperatorTypesRequests.update_priority(attrs)
    end

    test "FAULT update_priority/1 when id is not exist" do
      insert(:operator_type)
      id = FlakeId.get()
      attrs = [%{
        "id" => id,
        "active" => Map.get(@update_attrs, :active),
        "name" => Map.get(@update_attrs, :name),
        "priority" => Map.get(@update_attrs, :priority)
      }]
      assert {:error, %Postgrex.Error{
        connection_id: _,
        __exception__: true,
        message: nil,
        postgres: _,
        query: _
      }} = OperatorTypesRequests.update_priority(attrs)
    end

    test "FAULT update_priority/1 when attrs is nil" do
#      struct = insert(:operator_type)
#      attrs = [%{
#        "id" => struct.id,
#        "active" => Map.get(@invalid_attrs, :active),
#        "name" => Map.get(@invalid_attrs, :name),
#        "priority" => Map.get(@invalid_attrs, :priority)
#      }]
#      assert {:error, %Postgrex.Error{
#        connection_id: _,
#        __exception__: true,
#        message: nil,
#        postgres: _,
#        query: _
#      }} = OperatorTypesRequests.update_priority(attrs)
    end

    test "FAULT update_priority/1 when active is nil" do
#      struct = insert(:operator_type)
#      attrs = [%{
#        "id" => struct.id,
#        "active" => nil,
#        "name" => Map.get(@invalid_attrs, :name),
#        "priority" => Map.get(@invalid_attrs, :priority)
#      }]
#      assert {:error, %Postgrex.Error{
#        connection_id: _,
#        __exception__: true,
#        message: nil,
#        postgres: _,
#        query: _
#      }} = OperatorTypesRequests.update_priority(attrs)
    end

    test "FAULT update_priority/1 when priority is nil" do
#      struct = insert(:operator_type)
#      attrs = [%{
#        "id" => struct.id,
#        "active" => nil,
#        "name" => Map.get(@invalid_attrs, :name),
#        "priority" => nil
#      }]
#      assert {:error, %Postgrex.Error{
#        connection_id: _,
#        __exception__: true,
#        message: nil,
#        postgres: _,
#        query: _
#      }} = OperatorTypesRequests.update_priority(attrs)
    end

    test "FAULT update_priority/1 when priority is not integer" do
#      struct = insert(:operator_type)
#      attrs = [%{
#        "id" => struct.id,
#        "active" => nil,
#        "name" => Map.get(@invalid_attrs, :name),
#        "priority" => "xxx"
#      }]
#      assert {:error, %Postgrex.Error{
#        connection_id: _,
#        __exception__: true,
#        message: nil,
#        postgres: _,
#        query: _
#      }} = OperatorTypesRequests.update_priority(attrs)
    end
  end
end
