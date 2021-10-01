defmodule Core.Notifications.PatternNotificationTest do
  use Core.DataCase

  describe "pattern_notification" do
    alias Core.Notifications
    alias Core.Notifications.PatternNotification

    @valid_attrs %{
      action_type: "some text",
      full_text: "some text",
      template_type: "some text",
      title: "some text"
    }

    @invalid_attrs %{
      action_type: nil,
      full_text: nil,
      template_type: nil,
      title: nil
    }

    test "list_pattern_notifications/0" do
      struct = insert(:pattern_notification)
      [data] = Notifications.list_pattern_notifications()
      assert struct.action_type         == data.action_type
      assert struct.full_text           == data.full_text
      assert struct.need_auth           == data.need_auth
      assert struct.remove_previous     == data.remove_previous
      assert struct.short_text          == data.short_text
      assert struct.template_type       == data.template_type
      assert struct.time_to_live_in_sec == data.time_to_live_in_sec
      assert struct.title               == data.title
    end

    test "create_pattern_notification/1" do
      assert {:ok, %PatternNotification{} = created} = Notifications.create_pattern_notification(@valid_attrs)
      assert created.action_type         == "some text"
      assert created.full_text           == "some text"
      assert created.need_auth           == nil
      assert created.remove_previous     == nil
      assert created.short_text          == nil
      assert created.template_type       == "some text"
      assert created.time_to_live_in_sec == nil
      assert created.title               == "some text"
    end

    test "create_pattern_notification/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Notifications.create_pattern_notification(@invalid_attrs)
    end
  end
end
