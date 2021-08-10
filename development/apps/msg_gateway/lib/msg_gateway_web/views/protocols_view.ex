defmodule MsgGatewayWeb.ProtocolsView do
  @moduledoc false

  use MsgGatewayWeb, :view

  def render("protocols.json", %{protocols: protocols}) do
    %{"protocols" => protocols}
  end

  def render("protocols.json", %{fields: fields}) do
    %{"fields" => fields}
  end
end
