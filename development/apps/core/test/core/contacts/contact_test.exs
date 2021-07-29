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

    test "list_contacts/0 returns all Contacts" do
      operator = insert(:operator)
      struct = insert(:contact, operator: operator)
      struct.phone_number == "3801111111"
      struct.viber_id     == Map.get(@valid_attrs, :viber_id)
    end

    test "list_contacts/0" do
    end

    test "add_contact/1" do
    end

    test "add_contact/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Core.ContactsRequests.add_contact(@invalid_attrs)
    end

    test "change_contact/1" do
    end

    test "get_by_phone_number!/1" do
    end

    test "add_viber_id/1" do
    end

    test "add_operator_id/1" do
    end

    test "insert_or_update/2" do
    end

    test "delete/1" do
    end
  end
end
