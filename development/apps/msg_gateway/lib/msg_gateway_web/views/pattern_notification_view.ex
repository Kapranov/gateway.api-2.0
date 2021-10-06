defmodule MsgGatewayWeb.PatternNotificationView do
  @moduledoc false

  use MsgGatewayWeb, :view

  def render("create.json", %{status: insert_status}) do
    %{status: insert_status}
  end
end
