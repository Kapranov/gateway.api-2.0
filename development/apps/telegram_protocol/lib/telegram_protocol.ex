defmodule TelegramProtocol do
  @moduledoc false

  use GenServer

  alias TDLib.{Method, Object}
  alias TelegramProtocol.RedisManager

  @name __MODULE__
  @compile if Mix.env == :test, do: :export_all
  @tdlib Application.get_env(:telegram_protocol, TelegramProtocol)[:telegram_driver]

  @authentication_timeout 5000
  @protocol_config_def %{
    api_hash: "",
    api_id: "",
    code: "",
    method_name: :send_message,
    module_name: @name,
    password: "",
    phone: "",
    session_name: ""
  }

  def start_link(opts \\ []), do: GenServer.start_link(@name, opts, name: @name)

  def init(_opts) do
    {:ok, app_name} = :application.get_application(@name)

    RedisManager.get(Atom.to_string(app_name))
    |> check_config()
    GenServer.cast(MgLogger.Server, {:log, @name, %{"#{@name}" => "started"}})
    {:ok, []}
  end

  def start_telegram_lib() do
    Process.send_after(@name, :start_telegram_lib, 3000)
  end

  def check_correct_configs(true, _), do: :ok
  def check_correct_configs(false, protocol_config) do
    new_protocol = Map.merge(@protocol_config_def, protocol_config)
    {:ok, app_name} = :application.get_application(@name)
    RedisManager.set(Atom.to_string(app_name), new_protocol)
  end

  def telegram_authorization_process(%Object.AuthorizationStateWaitTdlibParameters{}), do: :ignore

  def telegram_authorization_process(%Object.AuthorizationStateWaitEncryptionKey{}), do: :ignore

  def telegram_authorization_process(%Object.AuthorizationStateWaitPhoneNumber{}) do
    {:ok, app_name} = :application.get_application(@name)
    protocol_config = RedisManager.get(Atom.to_string(app_name))
    query = %Method.SetAuthenticationPhoneNumber{
      phone_number: protocol_config.phone,
      allow_flash_call: false
    }
    @tdlib.transmit(String.to_atom(protocol_config.session_name), query)
  end

  def telegram_authorization_process(%Object.AuthorizationStateWaitCode{}), do: check_authentication_code()

  def telegram_authorization_process(%Object.AuthorizationStateWaitPassword{}), do: check_authentication_password()

  def telegram_authorization_process(%Object.AuthorizationStateReady{}), do: {:ok, :auth}

  def handle_info(:start_telegram_lib, _state) do
    {:ok, app_name} = :application.get_application(@name)

    RedisManager.get(Atom.to_string(app_name))
    |> check_config()

    {:noreply, []}
  end

  def handle_info({:recv, %Object.UpdateAuthorizationState{authorization_state: auth_state}}, state) do
    telegram_authorization_process(auth_state)
    {:noreply, state}
  end

  def handle_info(:check_authentication_code,  state) do
    {:ok, app_name} = :application.get_application(@name)

    RedisManager.get(Atom.to_string(app_name))
    |> send_code()

    {:noreply, state}
  end

  def handle_info(:check_authentication_password,  state) do
    {:ok, app_name} = :application.get_application(@name)
    RedisManager.get(Atom.to_string(app_name))
    |> send_password()

    {:noreply, state}
  end

  def handle_info({:recv, %Object.ImportedContacts{user_ids: [user_ids]}}, state) do
    select_user_info(user_ids)
    {:noreply, state}
  end

  def handle_info({:recv, %Object.User{id: user_id, phone_number: contact, type: %Object.UserTypeRegular{}}}, state) do
    message_info = Enum.find(state, &(&1.phone_number == "+" <> contact))
    old_state = List.delete(state, message_info)
    Process.cancel_timer(message_info.reference_create_account)
    reference = Process.send_after(@name, {:error_sending_messages, message_info.message_id}, 30000)
    new_state = %{user_id: user_id, phone_number: contact, message_id: message_info.message_id, error_reference: reference, body: message_info.body}
    query = %Method.CreatePrivateChat{user_id: user_id, force: false}
    do_query(query)
    {:noreply, [new_state | old_state]}
  end

  def handle_info({:recv, %Object.User{}}, state), do: state

  def handle_info({:recv, %Object.Chat{id: chat_id, type: %Object.ChatTypePrivate{user_id: user_id}}}, state) do
    message_info = Enum.find(state, &(&1.user_id == user_id))
    old_state = List.delete(state, message_info)
    new_state = Map.put(message_info, :chat_id, chat_id)
    query = %Method.SendMessage{
      chat_id: chat_id,
      disable_notification: false,
      from_background: true,
      input_message_content: %Object.InputMessageText{
        text: %Object.FormattedText{
          text: message_info.body
        }
      },
      reply_to_message_id: 0
    }
    do_query(query)
    {:noreply, [new_state | old_state]}
  end

  def handle_info({:recv, %Object.UpdateChatReadOutbox{chat_id: chat_id}}, state) do
    old_state =
      Enum.find(state, &(if Map.has_key?(&1, :chat_id) do &1.chat_id == chat_id end))
      |> remove_message_from_state(state)
    {:noreply, old_state}
  end

  def handle_info({:error_sending_messages, message_id}, state) do
    {_, old_state} = Enum.split_while(state, &(&1.message_id == message_id))
    spawn(TelegramProtocol, :end_sending_messages, [:error, message_id])
    {:noreply, old_state}
  end

  def handle_info(_,  state) do
    {:noreply, state}
  end

  def code() do
    {:ok, app_name} = :application.get_application(@name)
    protocol_config = RedisManager.get(Atom.to_string(app_name))
    send_code(protocol_config)
  end

  def handle_cast({:send_messages, payload},  state) do
    query = %Method.ImportContacts{contacts: [%{phone_number: payload.contact}]}
    do_query(query)
    reference = Process.send_after(@name, {:error_sending_messages, payload.message_id}, 3000)
    new_state = [%{phone_number: payload.contact, message_id: payload.message_id, reference_create_account: reference, body: payload.body}] ++ state
    {:noreply, new_state}
  end

  def select_user_info(0), do: :ignore
  def select_user_info("0"), do: :ignore
  def select_user_info(user_id) do
    query = %Method.GetUser{user_id: user_id}
    do_query(query)
  end

  def send_message(%{message_id: message_id} = payload) do
    GenServer.cast(MgLogger.Server, {:log, @name, %{:message_id => message_id, status: "sending_telegram"}})
    GenServer.cast(@name, {:send_messages, payload})
  end

  def end_sending_messages(:success, message_id) do
    message_status_info =
      RedisManager.get(message_id)
      |> Map.put(:sending_status, "read")

    RedisManager.set(message_id, message_status_info)
    {:ok, app_name} = :application.get_application(@name)
    RedisManager.get(Atom.to_string(app_name))
    apply(:'Elixir.MsgRouter', :send_message, [%{message_id: message_id}])
  end

  def end_sending_messages(:error, message_id) do
    message_status_info =
      RedisManager.get(message_id)
      |> Map.put(:sending_status, "sending Telegram error")

    RedisManager.set(message_id, message_status_info)
    {:ok, app_name} = :application.get_application(@name)
    RedisManager.get(Atom.to_string(app_name))
    apply(:'Elixir.MsgRouter', :send_message, [%{message_id: message_id}])
  end

  def check_config({:error, _}) do
    {:ok, app_name} = :application.get_application(@name)
    RedisManager.set(Atom.to_string(app_name), @protocol_config_def)
    start_telegram_lib()
  end

  def check_config(%{api_id: api_id, api_hash: api_hash, phone: phone, session_name: session_name})
       when api_id == "" and api_hash == "" and phone == "" and session_name == ""
    do
    start_telegram_lib()
  end

  def check_config(protocol_config) do
    check_correct_configs(Map.keys(protocol_config) ==  Map.keys(@protocol_config_def), protocol_config)
    config = struct(@tdlib.default_config(), %{api_id: String.to_integer(protocol_config.api_id), api_hash: protocol_config.api_hash})
    {:ok, _pid} = @tdlib.open(String.to_atom(protocol_config.session_name), self(), config)
    @tdlib.transmit(String.to_atom(protocol_config.session_name), "verbose 0")
  end

  defp check_authentication_code(), do: Process.send_after(@name, :check_authentication_code , @authentication_timeout)
  defp check_authentication_password(), do: Process.send_after(@name, :check_authentication_password , @authentication_timeout)

  defp send_code({:error, _}), do: check_authentication_code()
  defp send_code(%{code: code}) when code == "", do: check_authentication_code()
  defp send_code(protocol_config) do
    query = %Method.CheckAuthenticationCode{code: protocol_config.code}
    @tdlib.transmit(String.to_atom(protocol_config.session_name), query)
  end

  defp send_password({:error, _}), do: check_authentication_password()
  defp send_password(%{password: password}) when password == "", do: check_authentication_password()
  defp send_password(protocol_config) do
    query = %Method.CheckAuthenticationCode{code: protocol_config.password}
    @tdlib.transmit(String.to_atom(protocol_config.session_name), query)
  end

  defp remove_message_from_state(nil, state), do: state
  defp remove_message_from_state(message_info, state) do
    Process.cancel_timer(message_info.error_reference)
    spawn(TelegramProtocol, :end_sending_messages, [:success, message_info.message_id])
    List.delete(state, message_info)
  end

  defp do_query(query) do
    {:ok, app_name} = :application.get_application(@name)
    protocol_config = RedisManager.get(Atom.to_string(app_name))
    @tdlib.transmit(String.to_atom(protocol_config.session_name), query)
  end
end
