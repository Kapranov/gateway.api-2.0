defmodule Core.Operators.OperatorTest do
  use Core.DataCase

  describe "operator" do
    alias Core.{Operators, OperatorsRequests, Repo}

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

    test "list_operators/0 when list is empty" do
      data = OperatorsRequests.list_operators()
      assert data             == []
      assert Enum.count(data) == 0
    end

    test "add_operator/1" do
      operator_type = insert(:operator_type)
      param = Map.merge(@valid_attrs, %{operator_type_id: operator_type.id})
      attrs = %{
        "active" => param.active,
        "config" => param.config,
        "limit" => param.limit,
        "name" => param.name,
        "operator_type_id" => param.operator_type_id,
        "price" => param.price,
        "priority" => param.priority,
        "protocol_name" => param.protocol_name
      }

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

    test "add_operator/1 when operator_type_id is nil" do
      operator_type = insert(:operator_type)
      param = Map.merge(@valid_attrs, %{operator_type_id: operator_type.id})
      attrs = %{
        "active" => param.active,
        "config" => param.config,
        "limit" => param.limit,
        "name" => param.name,
        "operator_type_id" => nil,
        "price" => param.price,
        "priority" => param.priority,
        "protocol_name" => param.protocol_name
      }

      assert {:error, %Ecto.Changeset{}} = OperatorsRequests.add_operator(attrs)
    end

    test "add_operator/1 when is nil execept operator_type_id" do
      operator_type = insert(:operator_type)
      param = Map.merge(@valid_attrs, %{operator_type_id: operator_type.id})
      attrs = %{
        "active" => nil,
        "config" => nil,
        "limit" => nil,
        "name" => nil,
        "operator_type_id" => param.operator_type_id,
        "price" => nil,
        "priority" => nil,
        "protocol_name" => nil
      }

      assert {:error, %Ecto.Changeset{}} = OperatorsRequests.add_operator(attrs)
    end

    test "add_operator/1 when is not correct price" do
      operator_type = insert(:operator_type)
      param = Map.merge(@valid_attrs, %{operator_type_id: operator_type.id})
      attrs = %{
        "active" => param.active,
        "config" => param.config,
        "limit" => param.limit,
        "name" => param.name,
        "operator_type_id" => param.operator_type_id,
        "price" => "xxx",
        "priority" => param.priority,
        "protocol_name" => param.protocol_name
      }

      assert {:error, %Ecto.Changeset{}} = OperatorsRequests.add_operator(attrs)
    end

    test "add_operator/1 when is not correct limit" do
      operator_type = insert(:operator_type)
      param = Map.merge(@valid_attrs, %{operator_type_id: operator_type.id})
      attrs = %{
        "active" => param.active,
        "config" => param.config,
        "limit" => "xxx",
        "name" => param.name,
        "operator_type_id" => param.operator_type_id,
        "price" => param.price,
        "priority" => param.priority,
        "protocol_name" => param.protocol_name
      }

      assert {:error, %Ecto.Changeset{}} = OperatorsRequests.add_operator(attrs)
    end

    test "FAULT add_operator/1 when is not correct priority" do
      operator_type = insert(:operator_type)
      param = Map.merge(@valid_attrs, %{operator_type_id: operator_type.id})
      attrs = %{
        "active" => param.active,
        "config" => param.config,
        "limit" => param.limit,
        "name" => param.name,
        "operator_type_id" => param.operator_type_id,
        "price" => param.price,
        "priority" => "xxx",
        "protocol_name" => param.protocol_name
      }

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
      attrs = %{
        "active" => Map.get(@invalid_attrs, :active),
        "config" => Map.get(@invalid_attrs, :config),
        "limit" => Map.get(@invalid_attrs, :limit),
        "name" => Map.get(@invalid_attrs, :name),
        "price" => Map.get(@invalid_attrs, :price),
        "priority" => Map.get(@invalid_attrs, :priority),
        "protocol_name" => Map.get(@invalid_attrs, :protocol_name)
      }
      assert {:error, %Ecto.Changeset{}} = OperatorsRequests.add_operator(attrs)
    end

    test "change_operator/2" do
      operator_type = insert(:operator_type)
      struct = insert(:operator, operator_types: operator_type)
      attrs = Map.merge(@update_attrs, %{config: %{"bla" => "bla"}}) |> Map.to_list
      assert {1, nil} = OperatorsRequests.change_operator(struct.id, attrs)
    end

    test "FAULT change_operator/2 when is nil" do
#      operator_type = insert(:operator_type)
#      struct = insert(:operator, operator_types: operator_type)
#      attrs = Map.merge(@invalid_attrs, %{config: %{"bla" => "bla"}}) |> Map.to_list
#      assert {1, nil} = OperatorsRequests.change_operator(struct.id, attrs)
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

    test "FAULT get_by_name/1 when name is nil" do
#      operator_type = insert(:operator_type)
#      insert(:operator, operator_types: operator_type)
#      assert get_by_named = OperatorsRequests.get_by_name(nil)
    end

    test "FAULT get_by_name/1 when name is not correct" do
#      operator_type = insert(:operator_type)
#      insert(:operator, operator_types: operator_type)
#      assert get_by_named = OperatorsRequests.get_by_name("xxx")
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

    test "FAULT operator_by_id/1 when id is nil" do
#      operator_type = insert(:operator_type)
#      insert(:operator, operator_types: operator_type)
#      assert operator_by_id = OperatorsRequests.operator_by_id(nil)
    end

    test "FAULT operator_by_id/1 when id is not exist" do
#      operator_type = insert(:operator_type)
#      insert(:operator, operator_types: operator_type)
#      id = FlakeId.get()
#      assert operator_by_id = OperatorsRequests.operator_by_id(id)
    end

    test "operator_by_operator_type_id/1" do
      operator_type = insert(:operator_type)
      struct = insert(:operator, operator_types: operator_type)

      assert operator_typed = OperatorsRequests.operator_by_operator_type_id(operator_type.id)

      [loader] = operator_typed |> Repo.preload(:operator_types)

      assert loader == struct
    end

    test "FAULT operator_by_operator_type_id/1 when id is nil" do
#      operator_type = insert(:operator_type)
#      insert(:operator, operator_types: operator_type)
#      assert operator_typed = OperatorsRequests.operator_by_operator_type_id(nil)
    end

    test "FAULT operator_by_operator_type_id/1 when id is not exist" do
#      operator_type = insert(:operator_type)
#      insert(:operator, operator_types: operator_type)
#      id = FlakeId.get()
#      assert operator_typed = OperatorsRequests.operator_by_operator_type_id(id)
    end

    test "delete/1" do
      operator_type = insert(:operator_type)
      struct = insert(:operator, operator_types: operator_type)
      assert {1, nil} = OperatorsRequests.delete(struct.id)
    end

    test "FAULT delete/1 when id is nil" do
#      operator_type = insert(:operator_type)
#      insert(:operator, operator_types: operator_type)
#      assert {0, nil} = OperatorsRequests.delete(nil)
    end

    test "FAULT delete/1 when id is not exist" do
#      operator_type = insert(:operator_type)
#      insert(:operator, operator_types: operator_type)
#      id = FlakeId.get()
#      assert {0, nil} = OperatorsRequests.delete(id)
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

    test "FAULT update_priority/1 when is nil" do
#      operator_type = insert(:operator_type)
#      struct = insert(:operator, operator_types: operator_type)
#      attrs = Map.merge(@invalid_attrs, %{id: struct.id})
#      assert {:ok, %Postgrex.Result{
#        columns: nil,
#        command: :update,
#        connection_id: _,
#        messages: [],
#        num_rows: 1,
#        rows: nil
#      }} = OperatorsRequests.update_priority([attrs])
    end

    test "FAULT update_priority/1 when is not correct price" do
#      operator_type = insert(:operator_type)
#      struct = insert(:operator, operator_types: operator_type)
#      attrs = Map.merge(@invalid_attrs, %{id: struct.id, price: "xxx"})
#      assert {:ok, %Postgrex.Result{
#        columns: nil,
#        command: :update,
#        connection_id: _,
#        messages: [],
#        num_rows: 1,
#        rows: nil
#      }} = OperatorsRequests.update_priority([attrs])
    end

    test "FAULT update_priority/1 when is not correct limit" do
#      operator_type = insert(:operator_type)
#      struct = insert(:operator, operator_types: operator_type)
#      attrs = Map.merge(@invalid_attrs, %{id: struct.id, limit: "xxx"})
#      assert {:ok, %Postgrex.Result{
#        columns: nil,
#        command: :update,
#        connection_id: _,
#        messages: [],
#        num_rows: 1,
#        rows: nil
#      }} = OperatorsRequests.update_priority([attrs])
    end

    test "FAULT update_priority/1 when is not correct priority" do
#      operator_type = insert(:operator_type)
#      struct = insert(:operator, operator_types: operator_type)
#      attrs = Map.merge(@invalid_attrs, %{id: struct.id, priority: "xxx"})
#      assert {:ok, %Postgrex.Result{
#        columns: nil,
#        command: :update,
#        connection_id: _,
#        messages: [],
#        num_rows: 1,
#        rows: nil
#      }} = OperatorsRequests.update_priority([attrs])
    end

    test "FAULT update_priority/1 when id is nil" do
      operator_type = insert(:operator_type)
      insert(:operator, operator_types: operator_type)
      attrs = Map.merge(@update_attrs, %{id: nil})
      assert {:error, %Postgrex.Error{
        connection_id: _,
        __exception__: true,
        message: nil,
        postgres: _,
        query: _
      }} = OperatorsRequests.update_priority([attrs])
    end

    test "FAULT update_priority/1 when id is not exist" do
      operator_type = insert(:operator_type)
      insert(:operator, operator_types: operator_type)
      id = FlakeId.get()
      attrs = Map.merge(@update_attrs, %{id: id})
      assert {:error, %Postgrex.Error{
        connection_id: _,
        __exception__: true,
        message: nil,
        postgres: _,
        query: _
      }} = OperatorsRequests.update_priority([attrs])
    end
  end
end
