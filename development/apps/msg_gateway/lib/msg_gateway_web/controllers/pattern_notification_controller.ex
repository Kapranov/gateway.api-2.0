defmodule MsgGatewayWeb.PatternNotificationController do
  @moduledoc false

  use MsgGatewayWeb, :controller

  alias Core.Notifications

  action_fallback(MsgGatewayWeb.FallbackController)

  def create(conn, %{"resource" => %{
    "action_type" => action_type,
    "full_text" => full_text,
    "template_type" => template_type,
    "title" => title}})
  do
    with {:ok, _} <- Notifications.create_pattern_notification(
      %{
         action_type: action_type,
         full_text: full_text,
         template_type: template_type,
         title: title
       })
    do
      render(conn, "create.json", %{status: "success"})
    end
  end
end
