defmodule SmtpProtocol do
  @moduledoc false

  use GenServer

  alias SmtpProtocol.RedisManager

  @name __MODULE__
  @smtp_server Application.get_env(:smtp_protocol, SmtpProtocol.Mailer)[:smtp_mailer]

  @protocol_config   %{
    module_name: @name,
    method_name: :send_email
  }

  def start_link(opts \\ []), do: GenServer.start_link(@name, opts, name: @name)

  def init(_opts) do
    {:ok, app_name} = :application.get_application(@name)

    RedisManager.get(Atom.to_string(app_name))
    |> check_config()

    GenServer.cast(MgLogger.Server, {:log, @name, %{"#{@name}" => "started"}})

    {:ok, []}
  end

  def send_email(%{message_id: message_id, contact: recipient, body: body, subject: subject}) do
    SmtpProtocol.Email.email(recipient, subject, body)
    |> @smtp_server.deliver_now
    
    GenServer.cast(MgLogger.Server, {:log, @name, %{:message_id => message_id, status: "sending_smtp"}})

    message_status_info =
      RedisManager.get(message_id)
      |> Map.put(:sending_status, true)

    RedisManager.set(message_id, message_status_info)

    {:ok, app_name} = :application.get_application(@name)
    protocol =  RedisManager.get(Atom.to_string(app_name))
    apply(String.to_atom(protocol.module_name), String.to_atom(protocol.method_name), [%{message_id: message_id}])
  end

  defp check_config({:error, _}) do
    {:ok, app_name} = :application.get_application(@name)
    RedisManager.set(Atom.to_string(app_name), @protocol_config)
  end

  defp check_config(_protocol_config), do: :ok
end
