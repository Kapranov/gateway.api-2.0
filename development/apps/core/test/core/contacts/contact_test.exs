defmodule Core.Contacts.ContactTest do
  use Core.DataCase

  describe "contact" do
    alias Core.Contacts

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
  end
end
