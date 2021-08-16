defmodule SmsRouter.Application do
  @moduledoc false

  use Application

  @impl true
  @spec start(:normal | {:takeover, atom()} | {:failover, atom()}, start_args :: term()) ::
          {:ok, pid()} | {:ok, pid(), term()} | {:error, reason :: term()}
  def start(_type, _args) do
    config = Application.get_env(:sms_router,  SmsRouter.RedisManager)
    hostname = config[:host]
    password = config[:password]
    database = config[:database]
    port = config[:port]
    pool_size =  String.to_integer(config[:pool_size])
    children =
      for i <- 0..(pool_size - 1) do
        Supervisor.child_spec(
          {
            Redix, {
              "redis://#{password}@#{hostname}:#{port}/#{database}",
              name: :"redis_#{i}"
            }
          },
          id: {Redix, i}
        )
      end

    opts = [strategy: :one_for_one, name: SmsRouter.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
