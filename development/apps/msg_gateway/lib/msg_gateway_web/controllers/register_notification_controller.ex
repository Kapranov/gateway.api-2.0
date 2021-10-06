defmodule MsgGatewayWeb.RegisterNotificationController do
  @moduledoc false

  use MsgGatewayWeb, :controller

  alias Core.Notifications

  action_fallback(MsgGatewayWeb.FallbackController)

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
    Notifications.get_register_notification!(id)
    |> delete_register_notification(id, conn)
  end

  defp delete_register_notification([], id, conn) do
    with {_, nil} <- Notifications.delete_register_notification(id) do
      render(conn, "delete.json", %{status: "success"})
    end
  end

  defp delete_register_notification(_, _, _), do: {:error, :operators_present}
end
