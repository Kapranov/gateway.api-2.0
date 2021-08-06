defmodule MsgGatewayWeb.DefaultController do
  use MsgGatewayWeb, :controller

  def index(conn, _params), do: text conn, "MsgGatewayAPI"
end
