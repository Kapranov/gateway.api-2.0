defmodule MsgRouter.Application do
  @moduledoc false

  use Application

#  @impl true
#  def start(_type, _args) do
#    children = []
#    opts = [strategy: :one_for_one, name: MsgRouter.Supervisor]
#    Supervisor.start_link(children, opts)
#  end

  @spec start(:normal | {:takeover, atom()} | {:failover, atom()}, start_args :: term()) ::
          {:ok, pid()} | {:ok, pid(), term()} | {:error, reason :: term()}
  def start(_type, _args) do
    import Supervisor.Spec
    config = Application.get_env(:msg_router, MsgRouter.RedisManager)
    hostname = config[:host]
    password = config[:password]
    database = config[:database]
    port = config[:port]
    pool_size =  String.to_integer(config[:pool_size])
    {:ok, app_name} = :application.get_application(__MODULE__)

    redis_workers = for i <- 0..(pool_size - 1) do
      worker(Redix,
        ["redis://#{password}@#{hostname}:#{port}/#{database}",
          [name: :"redis_#{Atom.to_string(app_name)}_#{i}"]
        ],
        id: {Redix, i}
      )
    end
    children = redis_workers ++[
      worker(MsgRouter.MqManager, [])
    ]

    opts = [strategy: :one_for_one, name: MsgRouter.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
