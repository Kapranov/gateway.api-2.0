defmodule MgLogger.Server do
  @moduledoc false

  use GenServer

  @name __MODULE__

  @spec start_link() :: {:ok, pid()} | :ignore | {:error, {:already_started, pid()} | term()}
  def start_link(opts \\ []) do
    GenServer.start_link(@name, opts, name: @name)
  end

  @spec init(term()) :: {:ok, any()} | {:ok, any(), :infinity | non_neg_integer() | :hibernate | {:continue, term()}} | :ignore | {:stop, reason :: any()}
  def init(_opts) do
    url = Application.get_env(:mg_logger, :elasticsearch_url)
    {:ok, %{:url => url}}
  end

  def handle_cast({:log, _module, payload}, %{:url => url} = state) do
    payload_with_date = Map.put(payload, "date", DateTime.to_string(DateTime.utc_now()))
    HTTPoison.post(Enum.join([url, "/log/messages_gateway_api"]), Jason.encode!(payload_with_date), [{"Content-Type", "application/json"}])
    {:noreply, state}
  end

  def handle_cast(_msg, state), do: {:noreply, state}

  def handle_info(_msg, state), do: {:noreply, state}

  @spec terminate(reason, state :: term()) :: term()
        when reason: :normal | :shutdown | {:shutdown, term()}
  def terminate(_reason, state), do: state
end

