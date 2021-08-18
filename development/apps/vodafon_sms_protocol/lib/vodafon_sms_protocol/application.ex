defmodule VodafonSmsProtocol.Application do
  @moduledoc false

  use Application

  @name __MODULE__

  @spec start(:normal | {:takeover, atom()} | {:failover, atom()}, start_args :: term()) ::
          {:ok, pid()} | {:ok, pid(), term()} | {:error, reason :: term()}
  def start(_type, _args) do
    config = Application.get_env(:vodafon_sms_protocol, VodafonSmsProtocol.RedisManager)
    database = config[:database]
    hostname = config[:host]
    password = config[:password]
    pool_size =  String.to_integer(config[:pool_size])
    port = config[:port]
    {:ok, app_name} = :application.get_application(@name)

    children_redix =
      for i <- 0..(pool_size - 1) do
        Supervisor.child_spec(
          {
            Redix, {
              "redis://#{password}@#{hostname}:#{port}/#{database}",
              name: :"redis_#{Atom.to_string(app_name)}_#{i}"
            }
          },
          id: {Redix, i}
        )
      end

    children = [
      %{
        id: VodafonSmsProtocol.RedixSupervisor,
        type: :supervisor,
        start: {Supervisor, :start_link, [children_redix, [strategy: :one_for_one] ]} 
      },
      %{
        id: VodafonSmsProtocol,
        start: {VodafonSmsProtocol, :start_link, []}
       }
    ]

    opts = [strategy: :one_for_one, name: VodafonSmsProtocol.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
