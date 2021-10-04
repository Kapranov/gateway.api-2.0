defmodule Core.Notifications.RegisterNotificationTest do
  use Core.DataCase

  describe "pattern_notification" do
    alias Core.Notifications
    alias Core.Notifications.RegisterNotification

    @valid_attrs %{recipients: %{
      parameters: %{
        key: "some text",
        value: "some text"
      },
      resource_id: FlakeId.get(),
      rnokpp: "some text"
    }}
    @invalid_attrs %{recipients: nil}

    test "list_register_notifications/0" do
      pattern_notification = insert(:pattern_notification)
      struct = insert(:register_notification, pattern_notifications: pattern_notification)
      [data] = Notifications.list_register_notifications()
      assert data.pattern_notification_id                   == struct.pattern_notification_id
      assert data.pattern_notifications.action_type         == struct.pattern_notifications.action_type
      assert data.pattern_notifications.full_text           == struct.pattern_notifications.full_text
      assert data.pattern_notifications.need_auth           == struct.pattern_notifications.need_auth
      assert data.pattern_notifications.remove_previous     == struct.pattern_notifications.remove_previous
      assert data.pattern_notifications.short_text          == struct.pattern_notifications.short_text
      assert data.pattern_notifications.template_type       == struct.pattern_notifications.template_type
      assert data.pattern_notifications.time_to_live_in_sec == struct.pattern_notifications.time_to_live_in_sec
      assert data.pattern_notifications.title               == struct.pattern_notifications.title
      assert data.recipients["parameters"]["key"]           == struct.recipients.parameters.key
      assert data.recipients["parameters"]["value"]         == struct.recipients.parameters.value
      assert data.recipients["resource_id"]                 == struct.recipients.resource_id
      assert data.recipients["rnokpp"]                      == struct.recipients.rnokpp
    end

    test "create_register_notification/1" do
      pattern_notification = insert(:pattern_notification)
      attrs = Map.merge(@valid_attrs, %{
        pattern_notification_id: pattern_notification.id,
        recipients: %{
          parameters: %{
            key: "some text",
            value: "some text"
          },
          resource_id: FlakeId.get(),
          rnokpp: "some text"
        }
      })

      assert {:ok, %RegisterNotification{} = created} = Notifications.create_register_notification(attrs)

      loaded =
        created
        |> Repo.preload([:pattern_notifications])

      assert loaded.pattern_notification_id                   == pattern_notification.id
      assert loaded.pattern_notifications.action_type         == pattern_notification.action_type
      assert loaded.pattern_notifications.full_text           == pattern_notification.full_text
      assert loaded.pattern_notifications.need_auth           == pattern_notification.need_auth
      assert loaded.pattern_notifications.remove_previous     == pattern_notification.remove_previous
      assert loaded.pattern_notifications.short_text          == pattern_notification.short_text
      assert loaded.pattern_notifications.template_type       == pattern_notification.template_type
      assert loaded.pattern_notifications.time_to_live_in_sec == pattern_notification.time_to_live_in_sec
      assert loaded.pattern_notifications.title               == pattern_notification.title
      assert loaded.recipients.parameters.key                 == attrs.recipients.parameters.key
      assert loaded.recipients.parameters.value               == attrs.recipients.parameters.value
      assert loaded.recipients.resource_id                    == attrs.recipients.resource_id
      assert loaded.recipients.rnokpp                         == attrs.recipients.rnokpp
    end

    test "create_register_notification/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Notifications.create_register_notification(@invalid_attrs)
    end
  end
end
