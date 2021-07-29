defmodule Core.Operators.OperatorTest do
  use Core.DataCase

  describe "operator" do
    alias Core.Operators
    alias Core.OperatorsRequests
    alias Core.Repo

    @valid_attrs %{
      "active" => true,
      "config" => Map.new,
      "limit" => 22,
      "name" => "some text",
      "price" => 22,
      "priority" => 22,
      "protocol_name" => "some text"
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
      "active" => nil,
      "config" => nil,
      "limit" => nil,
      "name" => nil,
      "operator_type_id" => nil,
      "price" => nil,
      "priority" => nil,
      "protocol_name" => nil
    }

    test "list_operators/0" do
      operator_type = insert(:operator_type)
      struct = insert(:operator, operator_types: operator_type)
      [data] = OperatorsRequests.list_operators()
      operator_data = Map.get(data, :operator)
      operator_type_data = Map.get(data, :operator_type)

      assert operator_data.id               == struct.id
      assert operator_data.active           == struct.active
      assert operator_data.config           == struct.config
      assert operator_data.limit            == struct.limit
      assert operator_data.name             == struct.name
      assert operator_data.operator_type_id == struct.operator_type_id
      assert operator_data.price            == struct.price
      assert operator_data.priority         == struct.priority
      assert operator_data.protocol_name    == struct.protocol_name

      assert operator_type_data.id       == struct.operator_type_id
      assert operator_type_data.id       == struct.operator_types.id
      assert operator_type_data.active   == struct.operator_types.active
      assert operator_type_data.name     == struct.operator_types.name
      assert operator_type_data.priority == struct.operator_types.priority
    end

    test "add_operator/1" do
      operator_type = insert(:operator_type)
      attrs = Map.merge(@valid_attrs, %{"operator_type_id" => operator_type.id})

      assert {:ok, %Operators{} = struct} = OperatorsRequests.add_operator(attrs)
      assert struct.active           == true
      assert struct.config           == Map.new
      assert struct.limit            == 22
      assert struct.name             == "some text"
      assert struct.operator_type_id == operator_type.id
      assert struct.price            == 22
      assert struct.priority         == 1
      assert struct.protocol_name    == "some text"

      loader = struct |> Repo.preload(:operator_types)

      assert loader.operator_types.id       == operator_type.id
      assert loader.operator_types.active   == operator_type.active
      assert loader.operator_types.name     == operator_type.name
      assert loader.operator_types.priority == operator_type.priority
    end

    test "add_operator/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = OperatorsRequests.add_operator(@invalid_attrs)
    end

    test "change_operator/2" do
      operator_type = insert(:operator_type)
      struct = insert(:operator, operator_types: operator_type)
      attrs = Map.merge(@update_attrs, %{config: %{"bla" => "bla"}}) |> Map.to_list
      assert {1, nil} = OperatorsRequests.change_operator(struct.id, attrs)
    end

    test "get_by_name/1" do
      operator_type = insert(:operator_type)
      struct = insert(:operator, operator_types: operator_type)
      assert get_by_named = OperatorsRequests.get_by_name(struct.name)
      assert get_by_named.id               == struct.id
      assert get_by_named.active           == struct.active
      assert get_by_named.config           == struct.config
      assert get_by_named.limit            == struct.limit
      assert get_by_named.name             == struct.name
      assert get_by_named.operator_type_id == struct.operator_type_id
      assert get_by_named.price            == struct.price
      assert get_by_named.priority         == struct.priority
      assert get_by_named.protocol_name    == struct.protocol_name

      loader = struct |> Repo.preload(:operator_types)

      assert loader.operator_types.id       == operator_type.id
      assert loader.operator_types.active   == operator_type.active
      assert loader.operator_types.name     == operator_type.name
      assert loader.operator_types.priority == operator_type.priority
    end

    test "operator_by_id/1" do
      operator_type = insert(:operator_type)
      struct = insert(:operator, operator_types: operator_type)
      assert operator_by_id = OperatorsRequests.operator_by_id(struct.id)
      assert operator_by_id.id               == struct.id
      assert operator_by_id.active           == struct.active
      assert operator_by_id.config           == struct.config
      assert operator_by_id.limit            == struct.limit
      assert operator_by_id.name             == struct.name
      assert operator_by_id.operator_type_id == struct.operator_type_id
      assert operator_by_id.price            == struct.price
      assert operator_by_id.priority         == struct.priority
      assert operator_by_id.protocol_name    == struct.protocol_name

      loader = struct |> Repo.preload(:operator_types)

      assert loader.operator_types.id       == operator_type.id
      assert loader.operator_types.active   == operator_type.active
      assert loader.operator_types.name     == operator_type.name
      assert loader.operator_types.priority == operator_type.priority
    end

    test "operator_by_operator_type_id/1" do
      operator_type = insert(:operator_type)
      struct = insert(:operator, operator_types: operator_type)

      assert operator_typed = OperatorsRequests.operator_by_operator_type_id(operator_type.id)

      [loader] = operator_typed |> Repo.preload(:operator_types)

      assert loader == struct
    end

    test "delete/1" do
      operator_type = insert(:operator_type)
      struct = insert(:operator, operator_types: operator_type)
      assert {1, nil} = OperatorsRequests.delete(struct.id)
    end

    test "update_priority/1 with map's atom" do
      operator_type = insert(:operator_type)
      struct = insert(:operator, operator_types: operator_type)
      attrs = Map.merge(@update_attrs, %{id: struct.id})
      assert {:ok, %Postgrex.Result{
        columns: nil,
        command: :update,
        connection_id: _,
        messages: [],
        num_rows: 1,
        rows: nil
      }} = OperatorsRequests.update_priority([attrs])
    end

    test "update_priority/1 with map's string" do
      operator_type = insert(:operator_type)
      struct = insert(:operator, operator_types: operator_type)
      update_attrs = %{
        "active" => false,
        "config" => Map.new,
        "limit" => 99,
        "name" => "updated some text",
        "price" => 99,
        "priority" => 99,
        "protocol_name" => "updated some text"
      }

      attrs = Map.merge(update_attrs, %{"id" => struct.id})

      assert {:ok, %Postgrex.Result{
        columns: nil,
        command: :update,
        connection_id: _,
        messages: [],
        num_rows: 1,
        rows: nil
      }} = OperatorsRequests.update_priority([attrs])
    end
  end
end
