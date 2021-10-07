defmodule MsgGatewayWeb.RegisterNotificationController do
  @moduledoc false

  use MsgGatewayWeb, :controller

  alias Core.Notifications

  action_fallback(MsgGatewayWeb.FallbackController)

  def index(conn, _params) do
    with data <- Notifications.list_register_notifications() do
      render(conn, "index.json", %{register_notifications: data})
    end
  end

  def create(conn, %{"resource" => %{
    "pattern_notification_id" => pattern_notification_id,
    "recipients" => %{
      "parameters" => %{
        "key" => key,
        "value" => value
      },
      "resource_id" => resource_id,
      "rnokpp" => rnokpp
    }}}) 
  do
    with {:ok, _} <- Notifications.create_register_notification(%{
      pattern_notification_id: pattern_notification_id,
      recipients: %{
        parameters: %{key: key, value: value},
        resource_id: resource_id,
        rnokpp: rnokpp
      }})
    do
      render(conn, "create.json", %{status: "success"})
    end
  end

  def show(conn, %{"id" => id}) do
    with struct <- Notifications.get_register_notification!(id) do
      render(conn, "show.json", %{register_notification: struct})
    end
  end

  def delete(conn, %{"id" => id}) do
    with {_, nil} <- Notifications.delete_register_notification(id) do
      render(conn, "delete.json", %{status: "success"})
    end
  end
end
