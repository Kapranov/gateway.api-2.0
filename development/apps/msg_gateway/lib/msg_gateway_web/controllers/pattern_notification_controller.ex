defmodule MsgGatewayWeb.PatternNotificationController do
  @moduledoc false

  use MsgGatewayWeb, :controller

  alias Core.Notifications

  action_fallback(MsgGatewayWeb.FallbackController)

  def index(conn, _params) do
    with data <- Notifications.list_pattern_notifications() do
      render(conn, "index.json", %{pattern_notifications: data})
    end
  end

  def create(conn, %{"resource" => %{
    "action_type" => action_type,
    "full_text" => full_text,
    "need_auth" => need_auth,
    "remove_previous" => remove_previous,
    "short_text" => short_text,
    "template_type" => template_type,
    "time_to_live_in_sec" => time_to_live_in_sec,
    "title" => title}})
  do
    with {:ok, _} <- Notifications.create_pattern_notification(
      %{
         action_type: action_type,
         full_text: full_text,
         need_auth: need_auth,
         remove_previous: remove_previous,
         short_text: short_text,
         template_type: template_type,
         time_to_live_in_sec: time_to_live_in_sec,
         title: title
       })
    do
      render(conn, "create.json", %{status: "success"})
    end
  end
end
