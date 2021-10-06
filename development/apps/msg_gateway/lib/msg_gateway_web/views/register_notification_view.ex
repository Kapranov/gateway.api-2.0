defmodule MsgGatewayWeb.RegisterNotificationView do
  @moduledoc false

  use MsgGatewayWeb, :view

  def render("create.json", %{status: insert_status}) do
    %{status: insert_status}
  end

  def render("delete.json", %{status: delete_status}) do
    %{status: delete_status}
  end

  def render("show.json",%{register_notification: struct}) do
    %{
      id: struct.id,
      pattern_notification_id: struct.pattern_notification_id,
      recipients: %{
        parameters: %{
          key: struct.recipients.parameters.key,
          value: struct.recipients.parameters.value
        },
        resource_id: struct.recipients.resource_id,
        rnokpp: struct.recipients.rnokpp
      }
    }
  end
end
