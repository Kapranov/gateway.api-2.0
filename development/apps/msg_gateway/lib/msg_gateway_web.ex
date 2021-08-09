defmodule MsgGatewayWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use MsgGatewayWeb, :controller
      use MsgGatewayWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def controller do
    quote do
      use Phoenix.Controller, namespace: MsgGatewayWeb

      import Plug.Conn
      import MsgGatewayWeb.Proxy
      import MsgGateway.Plugs.Headers
      alias MsgGatewayWeb.Router.Helpers, as: Routes
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "",
        # root: "lib/msg_gateway_web/templates",
        namespace: MsgGatewayWeb

      import Phoenix.Controller,
        only: [get_flash: 1, get_flash: 2, view_module: 1, view_template: 1]

      unquote(view_helpers())
    end
  end

  def router do
    quote do
      use Phoenix.Router

      import Plug.Conn
      import Phoenix.Controller
      import MsgGateway.Plugs.Headers
    end
  end

  def plugs do
    quote do
      import MsgGatewayWeb.Proxy
      import Plug.Conn, only: [put_status: 2, halt: 1, get_req_header: 2, assign: 3]
      import Phoenix.Controller, only: [render: 2, render: 3, put_view: 2]
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
    end
  end

  defp view_helpers do
    quote do
      import Phoenix.View
      import MsgGatewayWeb.ErrorHelpers
      alias MsgGatewayWeb.Router.Helpers, as: Routes
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
