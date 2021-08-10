defmodule MsgGatewayWeb.KeysView do
  @moduledoc false

  use MsgGatewayWeb, :view

  def render("change_keys.json", %{:status => status}) do
    %{status: status}
  end

  def render("keys.json", %{:keys => keys}) do
    %{keys: keys}
  end
end
