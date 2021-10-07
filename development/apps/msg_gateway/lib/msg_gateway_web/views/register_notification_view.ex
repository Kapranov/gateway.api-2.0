defmodule MsgGatewayWeb.RegisterNotificationView do
  @moduledoc false

  use MsgGatewayWeb, :view

  @name __MODULE__

  def render("index.json",%{register_notifications: data}) do
    render_many(data, @name, "register_notification.json")
  end

  def render("create.json", %{status: insert_status}) do
    %{status: insert_status}
  end

  def render("delete.json", %{status: delete_status}) do
    %{status: delete_status}
  end

  def render("show.json",%{register_notification: struct}) do
    %{
      id: struct.id,
      inserted_at: struct.inserted_at,
      pattern_notification_id: struct.pattern_notification_id,
      recipients: %{
        parameters: %{
          key: struct.recipients["parameters"]["key"],
          value: struct.recipients["parameters"]["value"]
        },
        resource_id: struct.recipients["resource_id"],
        rnokpp: struct.recipients["rnokpp"]
      },
      updated_at: struct.updated_at
    }
  end

  def render("register_notification.json", %{register_notification: struct}) do
    %{
      id: struct.id,
      inserted_at: struct.inserted_at,
      pattern_notification_id: struct.pattern_notification_id,
      recipients: %{
        parameters: %{
          key: struct.recipients["parameters"]["key"],
          value: struct.recipients["parameters"]["value"]
        },
        resource_id: struct.recipients["resource_id"],
        rnokpp: struct.recipients["rnokpp"]
      },
      updated_at: struct.updated_at
    }
  end
end
