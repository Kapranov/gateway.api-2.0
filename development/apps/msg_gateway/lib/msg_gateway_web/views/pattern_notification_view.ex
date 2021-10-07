defmodule MsgGatewayWeb.PatternNotificationView do
  @moduledoc false

  use MsgGatewayWeb, :view

  @name __MODULE__

  def render("index.json",%{pattern_notifications: data}) do
    render_many(data, @name, "pattern_notification.json")
  end

  def render("create.json", %{status: insert_status}) do
    %{status: insert_status}
  end

  def render("pattern_notification.json", %{pattern_notification: struct}) do
    %{
      id: struct.id,
      action_type: struct.action_type,
      full_text: struct.full_text,
      inserted_at: struct.inserted_at,
      need_auth: struct.need_auth,
      remove_previous: struct.remove_previous,
      short_text: struct.short_text,
      template_type: struct.template_type,
      time_to_live_in_sec: struct.time_to_live_in_sec,
      title: struct.title,
      updated_at: struct.updated_at
    }
  end
end
