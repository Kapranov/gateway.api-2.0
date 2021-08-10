defmodule MsgGatewayWeb.SystemConfigView do
  @moduledoc false

  use MsgGatewayWeb, :view

  def render("index.json", %{:config => system_config}) do
    system_config
  end

  def render("change_system_config.json", _) do
    %{status: "success"}
  end
end
