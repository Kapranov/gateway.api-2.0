defmodule MsgGatewayWeb.MessageView do
  @moduledoc false

  use MsgGatewayWeb, :view

  def render("index.json", %{message_id: message_id, tag: tag}) do
    %{ "message_id" => message_id, "tag" => tag}
  end

  def render("queue_size.json", %{queue_size: queue_size, date_time: datetime}) do
    %{"queue_size" => queue_size, "date_time" => datetime}
  end

  def render("message_status.json", %{message_id: message_id, message_status: message_status}) do
    %{"message_id" => message_id, "message_status" => message_status}
  end

  def render("message_change_status.json", _) do
    %{message: "Status of sending was successfully changed"}
  end
end
