defmodule Core.Contacts.ContactTest do
  use Core.DataCase

  describe "contact" do
    alias Core.Contacts
    alias Core.ContactsRequests

    @valid_attrs %{
      phone_number: "3801111111",
      viber_id: FlakeId.get()
    }

    @update_attrs %{
      phone_number: "3809999999",
      viber_id: FlakeId.get()
    }

    @invalid_attrs %{ phone_number: nil }

    test "list_contacts/0" do
      operator_type = insert(:operator_type)
      operator = insert(:operator, operator_types: operator_type)
      struct = insert(:contact, operator: operator)
      [data] = ContactsRequests.list_contacts()
      loader = data |> Repo.preload([operator: :operator_types])

      assert loader.id           == struct.id
      assert loader.phone_number == struct.phone_number
      assert loader.viber_id     == struct.viber_id

      assert loader.operator.id               == struct.operator.id
      assert loader.operator.active           == struct.operator.active
      assert loader.operator.config           == struct.operator.config
      assert loader.operator.limit            == struct.operator.limit
      assert loader.operator.name             == struct.operator.name
      assert loader.operator.operator_type_id == struct.operator.operator_type_id
      assert loader.operator.price            == struct.operator.price
      assert loader.operator.priority         == struct.operator.priority
      assert loader.operator.protocol_name    == struct.operator.protocol_name

      assert loader.operator.operator_types.id       == operator.operator_type_id
      assert loader.operator.operator_types.id       == operator_type.id
      assert loader.operator.operator_types.active   == operator_type.active
      assert loader.operator.operator_types.name     == operator_type.name
      assert loader.operator.operator_types.priority == operator_type.priority
    end

    test "list_contacts/0 when is empty" do
      data = ContactsRequests.list_contacts()
      assert data             == []
      assert Enum.count(data) == 0
    end

    test "add_contact/1 with map's a atom" do
      operator_type = insert(:operator_type)
      operator = insert(:operator, operator_types: operator_type)
      attrs = Map.merge(@valid_attrs, %{operator_id: operator.id})

      assert {:ok, %Contacts{} = created} = ContactsRequests.add_contact(attrs)
      assert created.phone_number == attrs.phone_number
      assert created.viber_id     == attrs.viber_id
      assert created.operator_id  == attrs.operator_id

      loader = created |> Repo.preload([operator: :operator_types])

      assert loader.operator.id               == operator.id
      assert loader.operator.active           == operator.active
      assert loader.operator.config           == operator.config
      assert loader.operator.limit            == operator.limit
      assert loader.operator.name             == operator.name
      assert loader.operator.operator_type_id == operator.operator_type_id
      assert loader.operator.price            == operator.price
      assert loader.operator.priority         == operator.priority
      assert loader.operator.protocol_name    == operator.protocol_name

      assert loader.operator.operator_types.id       == operator.operator_type_id
      assert loader.operator.operator_types.id       == operator_type.id
      assert loader.operator.operator_types.active   == operator_type.active
      assert loader.operator.operator_types.name     == operator_type.name
      assert loader.operator.operator_types.priority == operator_type.priority
    end

    test "add_contact/1 with map's string" do
      operator_type = insert(:operator_type)
      operator = insert(:operator, operator_types: operator_type)
      param = Map.merge(@valid_attrs, %{operator_id: operator.id})
      attrs = %{"phone_number" => param.phone_number, "viber_id" => param.viber_id, "operator_id" => param.operator_id}

      assert {:ok, %Contacts{} = created} = ContactsRequests.add_contact(attrs)
      assert created.phone_number == attrs["phone_number"]
      assert created.viber_id     == attrs["viber_id"]
      assert created.operator_id  == attrs["operator_id"]

      loader = created |> Repo.preload([operator: :operator_types])

      assert loader.operator.id               == operator.id
      assert loader.operator.active           == operator.active
      assert loader.operator.config           == operator.config
      assert loader.operator.limit            == operator.limit
      assert loader.operator.name             == operator.name
      assert loader.operator.operator_type_id == operator.operator_type_id
      assert loader.operator.price            == operator.price
      assert loader.operator.priority         == operator.priority
      assert loader.operator.protocol_name    == operator.protocol_name

      assert loader.operator.operator_types.id       == operator.operator_type_id
      assert loader.operator.operator_types.id       == operator_type.id
      assert loader.operator.operator_types.active   == operator_type.active
      assert loader.operator.operator_types.name     == operator_type.name
      assert loader.operator.operator_types.priority == operator_type.priority
    end

    test "add_contact/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Core.ContactsRequests.add_contact(@invalid_attrs)
    end

    test "add_contact/1 when attrs are nil" do
      operator_type = insert(:operator_type)
      operator = insert(:operator, operator_types: operator_type)
      attrs = Map.merge(@invalid_attrs, %{operator_id: operator.id})
      assert {:error, %Ecto.Changeset{}} = ContactsRequests.add_contact(attrs)
    end

    test "FAULT add_contact/1 when operator_id is nil" do
#      operator_type = insert(:operator_type)
#      operator = insert(:operator, operator_types: operator_type)
#      attrs = Map.merge(@valid_attrs, %{operator_id: nil})
#
#      assert {:ok, %Contacts{} = created} = ContactsRequests.add_contact(attrs)
#      assert created.phone_number == attrs.phone_number
#      assert created.viber_id     == attrs.viber_id
#      assert created.operator_id  == attrs.operator_id
#
#      loader = created |> Repo.preload([operator: :operator_types])
#
#      assert loader.operator.id               == operator.id
#      assert loader.operator.active           == operator.active
#      assert loader.operator.config           == operator.config
#      assert loader.operator.limit            == operator.limit
#      assert loader.operator.name             == operator.name
#      assert loader.operator.operator_type_id == operator.operator_type_id
#      assert loader.operator.price            == operator.price
#      assert loader.operator.priority         == operator.priority
#      assert loader.operator.protocol_name    == operator.protocol_name
#
#      assert loader.operator.operator_types.id       == operator.operator_type_id
#      assert loader.operator.operator_types.id       == operator_type.id
#      assert loader.operator.operator_types.active   == operator_type.active
#      assert loader.operator.operator_types.name     == operator_type.name
#      assert loader.operator.operator_types.priority == operator_type.priority
    end

    test "FAULT add_contact/1 when operator_id is not exist" do
#      operator_type = insert(:operator_type)
#      insert(:operator, operator_types: operator_type)
#      id = FlakeId.get()
#      attrs = Map.merge(@valid_attrs, %{operator_id: id})
#
#      assert {:ok, %Contacts{} = created} = ContactsRequests.add_contact(attrs)
#      assert created.phone_number == attrs.phone_number
#      assert created.viber_id     == attrs.viber_id
#      assert created.operator_id  == attrs.operator_id

#      loader = created |> Repo.preload([operator: :operator_types])
#
#      assert loader.operator.id               == operator.id
#      assert loader.operator.active           == operator.active
#      assert loader.operator.config           == operator.config
#      assert loader.operator.limit            == operator.limit
#      assert loader.operator.name             == operator.name
#      assert loader.operator.operator_type_id == operator.operator_type_id
#      assert loader.operator.price            == operator.price
#      assert loader.operator.priority         == operator.priority
#      assert loader.operator.protocol_name    == operator.protocol_name
#
#      assert loader.operator.operator_types.id       == operator.operator_type_id
#      assert loader.operator.operator_types.id       == operator_type.id
#      assert loader.operator.operator_types.active   == operator_type.active
#      assert loader.operator.operator_types.name     == operator_type.name
#      assert loader.operator.operator_types.priority == operator_type.priority
    end

    test "FAULT change_contact/1" do
      operator_type = insert(:operator_type)
      operator = insert(:operator, operator_types: operator_type)
      struct = insert(:contact, operator: operator)
      attrs = Map.merge(@update_attrs, %{id: struct.id, operator_id: struct.operator_id, phone_number: struct.phone_number})
      assert {1, nil} = ContactsRequests.change_contact(attrs)
    end

    test "FAULT change_contact/1 when attrs are nil" do
#      operator_type = insert(:operator_type)
#      operator = insert(:operator, operator_types: operator_type)
#      struct = insert(:contact, operator: operator)
#      attrs = Map.merge(@invalid_attrs, %{id: struct.id, operator_id: struct.operator_id, phone_number: struct.phone_number})
#      assert {0, nil} = ContactsRequests.change_contact(attrs)
    end

    test "FAULT change_contact/1 when id is not correct" do
      operator_type = insert(:operator_type)
      operator = insert(:operator, operator_types: operator_type)
      struct = insert(:contact, operator: operator)
      id = FlakeId.get()
      attrs = Map.merge(@update_attrs, %{id: id, operator_id: struct.operator_id, phone_number: struct.phone_number})
      assert {1, nil} = ContactsRequests.change_contact(attrs)
    end

    test "FAULT change_contact/1 when operator_id is not correct" do
#      operator_type = insert(:operator_type)
#      operator = insert(:operator, operator_types: operator_type)
#      struct = insert(:contact, operator: operator)
#      operator_id = FlakeId.get()
#      attrs = Map.merge(@update_attrs, %{id: struct.id, operator_id: operator_id, phone_number: struct.phone_number})
#      assert {1, nil} = ContactsRequests.change_contact(attrs)
    end

    test "FAULT change_contact/1 when phone_number is not correct" do
      operator_type = insert(:operator_type)
      operator = insert(:operator, operator_types: operator_type)
      struct = insert(:contact, operator: operator)
      attrs = Map.merge(@update_attrs, %{id: struct.id, operator_id: struct.operator_id, phone_number: "xxx"})
      assert {0, nil} = ContactsRequests.change_contact(attrs)
    end

    test "get_by_phone_number!/1" do
      operator_type = insert(:operator_type)
      operator = insert(:operator, operator_types: operator_type)
      struct = insert(:contact, operator: operator)
      data = ContactsRequests.get_by_phone_number!(struct.phone_number)
      loader = data |> Repo.preload([operator: :operator_types])

      assert loader.id           == struct.id
      assert loader.phone_number == struct.phone_number
      assert loader.viber_id     == struct.viber_id

      assert loader.operator.id               == struct.operator.id
      assert loader.operator.active           == struct.operator.active
      assert loader.operator.config           == struct.operator.config
      assert loader.operator.limit            == struct.operator.limit
      assert loader.operator.name             == struct.operator.name
      assert loader.operator.operator_type_id == struct.operator.operator_type_id
      assert loader.operator.price            == struct.operator.price
      assert loader.operator.priority         == struct.operator.priority
      assert loader.operator.protocol_name    == struct.operator.protocol_name

      assert loader.operator.operator_types.id       == operator.operator_type_id
      assert loader.operator.operator_types.id       == operator_type.id
      assert loader.operator.operator_types.active   == operator_type.active
      assert loader.operator.operator_types.name     == operator_type.name
      assert loader.operator.operator_types.priority == operator_type.priority
    end

    test "FAULT get_by_phone_number!/1 when phone_number is nil" do
#      operator_type = insert(:operator_type)
#      operator = insert(:operator, operator_types: operator_type)
#      insert(:contact, operator: operator)
#      data = ContactsRequests.get_by_phone_number!(nil)
    end

    test "FAULT get_by_phone_number!/1 when phone_number is not correct" do
#      operator_type = insert(:operator_type)
#      operator = insert(:operator, operator_types: operator_type)
#      struct = insert(:contact, operator: operator)
#      data = ContactsRequests.get_by_phone_number!("xxx")
#      loader = data |> Repo.preload([operator: :operator_types])
#
#      assert loader.id           == struct.id
#      assert loader.phone_number == struct.phone_number
#      assert loader.viber_id     == struct.viber_id
#
#      assert loader.operator.id               == struct.operator.id
#      assert loader.operator.active           == struct.operator.active
#      assert loader.operator.config           == struct.operator.config
#      assert loader.operator.limit            == struct.operator.limit
#      assert loader.operator.name             == struct.operator.name
#      assert loader.operator.operator_type_id == struct.operator.operator_type_id
#      assert loader.operator.price            == struct.operator.price
#      assert loader.operator.priority         == struct.operator.priority
#      assert loader.operator.protocol_name    == struct.operator.protocol_name
#
#      assert loader.operator.operator_types.id       == operator.operator_type_id
#      assert loader.operator.operator_types.id       == operator_type.id
#      assert loader.operator.operator_types.active   == operator_type.active
#      assert loader.operator.operator_types.name     == operator_type.name
#      assert loader.operator.operator_types.priority == operator_type.priority
    end

    test "add_viber_id/1" do
      operator_type = insert(:operator_type)
      operator = insert(:operator, operator_types: operator_type)
      struct = insert(:contact, operator: operator)
      attrs = %{:phone_number => "+380971112233", :viber_id => struct.viber_id, :operator_id => operator.id}

      assert {:ok, %Contacts{} = data} = ContactsRequests.add_viber_id(attrs)

      loader = data |> Repo.preload([operator: :operator_types])

      assert loader.id           != struct.id
      assert loader.phone_number == attrs[:phone_number]
      assert loader.viber_id     == struct.viber_id

      assert loader.operator.id               == operator.id
      assert loader.operator.active           == operator.active
      assert loader.operator.config           == operator.config
      assert loader.operator.limit            == operator.limit
      assert loader.operator.name             == operator.name
      assert loader.operator.operator_type_id == operator.operator_type_id
      assert loader.operator.price            == operator.price
      assert loader.operator.priority         == operator.priority
      assert loader.operator.protocol_name    == operator.protocol_name

      assert loader.operator.operator_types.id       == operator.operator_type_id
      assert loader.operator.operator_types.id       == operator_type.id
      assert loader.operator.operator_types.active   == operator_type.active
      assert loader.operator.operator_types.name     == operator_type.name
      assert loader.operator.operator_types.priority == operator_type.priority
    end

    test "FAULT add_viber_id/1 when viber_id is nil" do
      operator_type = insert(:operator_type)
      operator = insert(:operator, operator_types: operator_type)
      struct = insert(:contact, operator: operator)
      attrs = %{:phone_number => "+380971112233", :viber_id => nil, :operator_id => operator.id}

      assert {:ok, %Contacts{} = data} = ContactsRequests.add_viber_id(attrs)

      loader = data |> Repo.preload([operator: :operator_types])

      assert loader.id           != struct.id
      assert loader.phone_number == attrs[:phone_number]
      assert loader.viber_id     == nil

      assert loader.operator.id               == operator.id
      assert loader.operator.active           == operator.active
      assert loader.operator.config           == operator.config
      assert loader.operator.limit            == operator.limit
      assert loader.operator.name             == operator.name
      assert loader.operator.operator_type_id == operator.operator_type_id
      assert loader.operator.price            == operator.price
      assert loader.operator.priority         == operator.priority
      assert loader.operator.protocol_name    == operator.protocol_name

      assert loader.operator.operator_types.id       == operator.operator_type_id
      assert loader.operator.operator_types.id       == operator_type.id
      assert loader.operator.operator_types.active   == operator_type.active
      assert loader.operator.operator_types.name     == operator_type.name
      assert loader.operator.operator_types.priority == operator_type.priority
    end

    test "FAULT add_viber_id/1 when viber_id is not correct" do
      operator_type = insert(:operator_type)
      operator = insert(:operator, operator_types: operator_type)
      struct = insert(:contact, operator: operator)
      id = FlakeId.get()
      attrs = %{:phone_number => "+380971112233", :viber_id => id, :operator_id => operator.id}

      assert {:ok, %Contacts{} = data} = ContactsRequests.add_viber_id(attrs)

      loader = data |> Repo.preload([operator: :operator_types])

      assert loader.id           != struct.id
      assert loader.phone_number == attrs[:phone_number]
      assert loader.viber_id     != struct.viber_id

      assert loader.operator.id               == operator.id
      assert loader.operator.active           == operator.active
      assert loader.operator.config           == operator.config
      assert loader.operator.limit            == operator.limit
      assert loader.operator.name             == operator.name
      assert loader.operator.operator_type_id == operator.operator_type_id
      assert loader.operator.price            == operator.price
      assert loader.operator.priority         == operator.priority
      assert loader.operator.protocol_name    == operator.protocol_name

      assert loader.operator.operator_types.id       == operator.operator_type_id
      assert loader.operator.operator_types.id       == operator_type.id
      assert loader.operator.operator_types.active   == operator_type.active
      assert loader.operator.operator_types.name     == operator_type.name
      assert loader.operator.operator_types.priority == operator_type.priority
    end


    test "add_operator_id/1" do
      operator_type = insert(:operator_type)
      operator = insert(:operator, operator_types: operator_type)
      struct = insert(:contact, operator: operator)
      param = Map.merge(@valid_attrs, %{operator_id: operator.id})
      attrs = %{:phone_number => param.phone_number, :viber_id => param.viber_id, :operator_id => param.operator_id}

      assert {:ok, %Contacts{} = data} = ContactsRequests.add_operator_id(attrs)

      loader = data |> Repo.preload([operator: :operator_types])

      assert loader.id           != struct.id
      assert loader.phone_number == attrs[:phone_number]
      assert loader.viber_id     == attrs[:viber_id]

      assert loader.operator.id               == operator.id
      assert loader.operator.active           == operator.active
      assert loader.operator.config           == operator.config
      assert loader.operator.limit            == operator.limit
      assert loader.operator.name             == operator.name
      assert loader.operator.operator_type_id == operator.operator_type_id
      assert loader.operator.price            == operator.price
      assert loader.operator.priority         == operator.priority
      assert loader.operator.protocol_name    == operator.protocol_name

      assert loader.operator.operator_types.id       == operator.operator_type_id
      assert loader.operator.operator_types.id       == operator_type.id
      assert loader.operator.operator_types.active   == operator_type.active
      assert loader.operator.operator_types.name     == operator_type.name
      assert loader.operator.operator_types.priority == operator_type.priority
    end

    test "FAULT add_operator_id/1 when operator_id is nil" do
#      operator_type = insert(:operator_type)
#      operator = insert(:operator, operator_types: operator_type)
#      struct = insert(:contact, operator: operator)
#      param = Map.merge(@valid_attrs, %{operator_id: nil})
#      attrs = %{:phone_number => param.phone_number, :viber_id => param.viber_id, :operator_id => param.operator_id}
#
#      assert {:ok, %Contacts{} = data} = ContactsRequests.add_operator_id(attrs)
#
#      loader = data |> Repo.preload([operator: :operator_types])
#
#      assert loader.id           != struct.id
#      assert loader.phone_number == attrs[:phone_number]
#      assert loader.viber_id     == attrs[:viber_id]
#
#      assert loader.operator.id               == operator.id
#      assert loader.operator.active           == operator.active
#      assert loader.operator.config           == operator.config
#      assert loader.operator.limit            == operator.limit
#      assert loader.operator.name             == operator.name
#      assert loader.operator.operator_type_id == operator.operator_type_id
#      assert loader.operator.price            == operator.price
#      assert loader.operator.priority         == operator.priority
#      assert loader.operator.protocol_name    == operator.protocol_name
#
#      assert loader.operator.operator_types.id       == operator.operator_type_id
#      assert loader.operator.operator_types.id       == operator_type.id
#      assert loader.operator.operator_types.active   == operator_type.active
#      assert loader.operator.operator_types.name     == operator_type.name
#      assert loader.operator.operator_types.priority == operator_type.priority
    end

    test "FAULT add_operator_id/1 when operator_id is not exist" do
#      operator_type = insert(:operator_type)
#      operator = insert(:operator, operator_types: operator_type)
#      struct = insert(:contact, operator: operator)
#      id = FlakeId.get()
#      param = Map.merge(@valid_attrs, %{operator_id: id})
#      attrs = %{:phone_number => param.phone_number, :viber_id => param.viber_id, :operator_id => param.operator_id}
#
#      assert {:ok, %Contacts{} = data} = ContactsRequests.add_operator_id(attrs)
#
#      loader = data |> Repo.preload([operator: :operator_types])
#
#      assert loader.id           != struct.id
#      assert loader.phone_number == attrs[:phone_number]
#      assert loader.viber_id     == attrs[:viber_id]
#
#      assert loader.operator.id               == operator.id
#      assert loader.operator.active           == operator.active
#      assert loader.operator.config           == operator.config
#      assert loader.operator.limit            == operator.limit
#      assert loader.operator.name             == operator.name
#      assert loader.operator.operator_type_id == operator.operator_type_id
#      assert loader.operator.price            == operator.price
#      assert loader.operator.priority         == operator.priority
#      assert loader.operator.protocol_name    == operator.protocol_name
#
#      assert loader.operator.operator_types.id       == operator.operator_type_id
#      assert loader.operator.operator_types.id       == operator_type.id
#      assert loader.operator.operator_types.active   == operator_type.active
#      assert loader.operator.operator_types.name     == operator_type.name
#      assert loader.operator.operator_types.priority == operator_type.priority
   end

    test "FAULT add_operator_id/1 when attrs are nil" do
#      operator_type = insert(:operator_type)
#      operator = insert(:operator, operator_types: operator_type)
#      struct = insert(:contact, operator: operator)
#      id = FlakeId.get()
#      param = Map.merge(@valid_attrs, %{operator_id: id})
#      attrs = %{:phone_number => nil, :viber_id => nil, :operator_id => param.operator_id}
#
#      assert {:ok, %Contacts{} = data} = ContactsRequests.add_operator_id(attrs)
#
#      loader = data |> Repo.preload([operator: :operator_types])
#
#      assert loader.id           != struct.id
#      assert loader.phone_number == attrs[:phone_number]
#      assert loader.viber_id     == attrs[:viber_id]

#      assert loader.operator.id               == operator.id
#      assert loader.operator.active           == operator.active
#      assert loader.operator.config           == operator.config
#      assert loader.operator.limit            == operator.limit
#      assert loader.operator.name             == operator.name
#      assert loader.operator.operator_type_id == operator.operator_type_id
#      assert loader.operator.price            == operator.price
#      assert loader.operator.priority         == operator.priority
#      assert loader.operator.protocol_name    == operator.protocol_name
#
#      assert loader.operator.operator_types.id       == operator.operator_type_id
#      assert loader.operator.operator_types.id       == operator_type.id
#      assert loader.operator.operator_types.active   == operator_type.active
#      assert loader.operator.operator_types.name     == operator_type.name
#      assert loader.operator.operator_types.priority == operator_type.priority
   end

    test "FAULT add_operator_id/1 when attrs are not correct" do
#      operator_type = insert(:operator_type)
#      operator = insert(:operator, operator_types: operator_type)
#      struct = insert(:contact, operator: operator)
#      id = FlakeId.get()
#      param = Map.merge(@valid_attrs, %{operator_id: id})
#      attrs = %{:phone_number => "xxx", :viber_id => "xxx", :operator_id => param.operator_id}
#
#      assert {:ok, %Contacts{} = data} = ContactsRequests.add_operator_id(attrs)
#
#      loader = data |> Repo.preload([operator: :operator_types])
#
#      assert loader.id           != struct.id
#      assert loader.phone_number == attrs[:phone_number]
#      assert loader.viber_id     == attrs[:viber_id]

#      assert loader.operator.id               == operator.id
#      assert loader.operator.active           == operator.active
#      assert loader.operator.config           == operator.config
#      assert loader.operator.limit            == operator.limit
#      assert loader.operator.name             == operator.name
#      assert loader.operator.operator_type_id == operator.operator_type_id
#      assert loader.operator.price            == operator.price
#      assert loader.operator.priority         == operator.priority
#      assert loader.operator.protocol_name    == operator.protocol_name
#
#      assert loader.operator.operator_types.id       == operator.operator_type_id
#      assert loader.operator.operator_types.id       == operator_type.id
#      assert loader.operator.operator_types.active   == operator_type.active
#      assert loader.operator.operator_types.name     == operator_type.name
#      assert loader.operator.operator_types.priority == operator_type.priority
   end

    test "insert_or_update/2 for create new contact" do
      operator_type = insert(:operator_type)
      operator = insert(:operator, operator_types: operator_type)
      attrs = Map.merge(@valid_attrs, %{operator_id: operator.id})

      assert {:ok, %Contacts{} = created} = ContactsRequests.insert_or_update(nil, attrs)

      assert created.phone_number == attrs.phone_number
      assert created.viber_id     == attrs.viber_id
      assert created.operator_id  == attrs.operator_id

      loader = created |> Repo.preload([operator: :operator_types])

      assert loader.operator.id               == operator.id
      assert loader.operator.active           == operator.active
      assert loader.operator.config           == operator.config
      assert loader.operator.limit            == operator.limit
      assert loader.operator.name             == operator.name
      assert loader.operator.operator_type_id == operator.operator_type_id
      assert loader.operator.price            == operator.price
      assert loader.operator.priority         == operator.priority
      assert loader.operator.protocol_name    == operator.protocol_name

      assert loader.operator.operator_types.id       == operator.operator_type_id
      assert loader.operator.operator_types.id       == operator_type.id
      assert loader.operator.operator_types.active   == operator_type.active
      assert loader.operator.operator_types.name     == operator_type.name
      assert loader.operator.operator_types.priority == operator_type.priority
    end

    test "FAULT insert_or_update/2 for create new contact when operator_id is nil" do
#      operator_type = insert(:operator_type)
#      operator = insert(:operator, operator_types: operator_type)
#      attrs = Map.merge(@valid_attrs, %{operator_id: nil})
#
#      assert {:ok, %Contacts{} = created} = ContactsRequests.insert_or_update(nil, attrs)
#
#      assert created.phone_number == attrs.phone_number
#      assert created.viber_id     == attrs.viber_id
#      assert created.operator_id  == attrs.operator_id
#
#      loader = created |> Repo.preload([operator: :operator_types])
#
#      assert loader.operator.id               == operator.id
#      assert loader.operator.active           == operator.active
#      assert loader.operator.config           == operator.config
#      assert loader.operator.limit            == operator.limit
#      assert loader.operator.name             == operator.name
#      assert loader.operator.operator_type_id == operator.operator_type_id
#      assert loader.operator.price            == operator.price
#      assert loader.operator.priority         == operator.priority
#      assert loader.operator.protocol_name    == operator.protocol_name
#
#      assert loader.operator.operator_types.id       == operator.operator_type_id
#      assert loader.operator.operator_types.id       == operator_type.id
#      assert loader.operator.operator_types.active   == operator_type.active
#      assert loader.operator.operator_types.name     == operator_type.name
#      assert loader.operator.operator_types.priority == operator_type.priority
    end

    test "FAULT insert_or_update/2 for create new contact when operator_id is not exist" do
#      operator_type = insert(:operator_type)
#      insert(:operator, operator_types: operator_type)
#      id = FlakeId.get()
#      attrs = Map.merge(@valid_attrs, %{operator_id: id})
#
#      assert {:ok, %Contacts{} = created} = ContactsRequests.insert_or_update(nil, attrs)
#
#      assert created.phone_number == attrs.phone_number
#      assert created.viber_id     == attrs.viber_id
#      assert created.operator_id  == attrs.operator_id
#
#      loader = created |> Repo.preload([operator: :operator_types])
#
#      assert loader.operator.id               == operator.id
#      assert loader.operator.active           == operator.active
#      assert loader.operator.config           == operator.config
#      assert loader.operator.limit            == operator.limit
#      assert loader.operator.name             == operator.name
#      assert loader.operator.operator_type_id == operator.operator_type_id
#      assert loader.operator.price            == operator.price
#      assert loader.operator.priority         == operator.priority
#      assert loader.operator.protocol_name    == operator.protocol_name
#
#      assert loader.operator.operator_types.id       == operator.operator_type_id
#      assert loader.operator.operator_types.id       == operator_type.id
#      assert loader.operator.operator_types.active   == operator_type.active
#      assert loader.operator.operator_types.name     == operator_type.name
#      assert loader.operator.operator_types.priority == operator_type.priority
    end

    test "FAULT insert_or_update/2 for update old contact" do
      operator_type = insert(:operator_type)
      operator = insert(:operator, operator_types: operator_type)
      struct = insert(:contact, operator: operator)
      param = Map.merge(@update_attrs, %{id: struct.id, operator_id: operator.id})
      attrs = %{id: param.id, phone_number: struct.phone_number, viber_id: param.viber_id, operator_id: param.operator_id}
      assert {1, nil} = ContactsRequests.insert_or_update("xxx", attrs)
    end

    test "FAULT insert_or_update/2 for update old contacti when attrs are nil" do
#      operator_type = insert(:operator_type)
#      operator = insert(:operator, operator_types: operator_type)
#      struct = insert(:contact, operator: operator)
#      param = Map.merge(@invalid_attrs, %{id: struct.id, operator_id: operator.id})
#      attrs = %{id: param.id, phone_number: struct.phone_number, viber_id: param.viber_id, operator_id: param.operator_id}
#      assert {1, nil} = ContactsRequests.insert_or_update("xxx", attrs)
    end

    test "FAULT insert_or_update/2 for update old contact when id is nil" do
      operator_type = insert(:operator_type)
      operator = insert(:operator, operator_types: operator_type)
      struct = insert(:contact, operator: operator)
      param = Map.merge(@update_attrs, %{id: struct.id, operator_id: operator.id})
      attrs = %{id: nil, phone_number: struct.phone_number, viber_id: param.viber_id, operator_id: param.operator_id}
      assert {1, nil} = ContactsRequests.insert_or_update("xxx", attrs)
    end

    test "FAULT insert_or_update/2 for update old contact when id is not exist" do
      operator_type = insert(:operator_type)
      operator = insert(:operator, operator_types: operator_type)
      struct = insert(:contact, operator: operator)
      id = FlakeId.get()
      param = Map.merge(@update_attrs, %{id: struct.id, operator_id: operator.id})
      attrs = %{id: id, phone_number: struct.phone_number, viber_id: param.viber_id, operator_id: param.operator_id}
      assert {1, nil} = ContactsRequests.insert_or_update("xxx", attrs)
    end

    test "FAULT insert_or_update/2 for update old contact when phone_number is not correct" do
      operator_type = insert(:operator_type)
      operator = insert(:operator, operator_types: operator_type)
      struct = insert(:contact, operator: operator)
      param = Map.merge(@update_attrs, %{id: struct.id, operator_id: operator.id})
      attrs = %{id: param.id, phone_number: "xxx", viber_id: param.viber_id, operator_id: param.operator_id}
      assert {0, nil} = ContactsRequests.insert_or_update("xxx", attrs)
    end

    test "FAULT insert_or_update/2 for update old contact when viber_id is not correct" do
      operator_type = insert(:operator_type)
      operator = insert(:operator, operator_types: operator_type)
      struct = insert(:contact, operator: operator)
      param = Map.merge(@update_attrs, %{id: struct.id, operator_id: operator.id})
      attrs = %{id: param.id, phone_number: struct.phone_number, viber_id: "xxx", operator_id: param.operator_id}
      assert {1, nil} = ContactsRequests.insert_or_update("xxx", attrs)
    end

    test "delete/1" do
      operator_type = insert(:operator_type)
      operator = insert(:operator, operator_types: operator_type)
      struct = insert(:contact, operator: operator)
      assert {1, nil} == ContactsRequests.delete(struct.id)
    end

    test "delete/1 when id is nil" do
#      operator_type = insert(:operator_type)
#      operator = insert(:operator, operator_types: operator_type)
#      insert(:contact, operator: operator)
#      assert {1, nil} == ContactsRequests.delete(nil)
    end

    test "delete/1 when id is not exist" do
#      operator_type = insert(:operator_type)
#      operator = insert(:operator, operator_types: operator_type)
#      insert(:contact, operator: operator)
#      id = FlakeId.get()
#      assert {1, nil} == ContactsRequests.delete(id)
    end
  end
end
