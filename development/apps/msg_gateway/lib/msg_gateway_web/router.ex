defmodule MsgGatewayWeb.Router do
  @moduledoc false

  use MsgGatewayWeb, :router
  use Plug.ErrorHandler

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug :required_headers
  end

  scope "/api", MsgGatewayWeb do
    pipe_through :api

    post "/system_config", SystemConfigController, :add

    scope "/operator_type"  do
      post "/deactivate", OperatorTypeController, :deactivate
      resources "/", OperatorTypeController, except: [:new, :show, :edit, :update]
      post "/update_priority", OperatorTypeController, :update_priority
    end

    scope "/get_protocol" do
      resources "/", ProtocolsController, except: [:new, :edit, :update, :create, :delete]
    end

    scope "/operators" do
      post "/change", OperatorsController, :change_info
      resources "/", OperatorsController, except: [:new, :edit, :update]
    end

    scope "/system_config" do
      post "/system_config", SystemConfigController, :add
      resources "/", SystemConfigController, except: [:new, :edit, :update, :create, :delete, :show]
    end

    scope "/keys" do
      post "/deactivate", KeysController, :deactivate
      post "/activate", KeysController, :activate
      get "/all", KeysController, :get_all
      resources "/", KeysController, except: [:new, :edit, :update, :create]
    end

    scope "/v1" do
      post "/notification/template", PatternNotificationController, :create
      post "/notification/distribution/push", RegisterNotificationController, :create
      delete "/notification/distribution/push/:id", RegisterNotificationController, :delete
      get "/notification/template", PatternNotificationController, :index
      get "/notification/distribution/push", RegisterNotificationController, :index
      get "/notification/distribution/push/:id", RegisterNotificationController, :show
      get "/notification/distribution/push/:id/status", RegisterNotificationController, :show
    end
  end

  scope "/message", MsgGatewayWeb do
    resources "/", MessageController, except: [:new, :edit, :update, :delete, :index]
  end

  scope "/sending", MsgGatewayWeb do
    pipe_through [:api, :auth]

    post "/email", MessageController, :new_email
    get "/queue_size", MessageController, :queue_size
    post "/change_message_status", MessageController, :change_message_status
  end

  scope "/", MsgGatewayWeb do
    pipe_through :api

    get "/", DefaultController, :index
  end

  defp handle_errors(%Plug.Conn{status: 500} = conn, %{kind: _kind, reason: _reason, stack: _stacktrace}) do
     send_resp(conn, 500, Jason.encode!(%{errors: %{detail: "Internal server error"}}))
  end
  defp handle_errors(_, _), do: nil
end
