defmodule MsgGateway.Application do
  use Application

  @name __MODULE__

  @spec start(type, args) :: result when
          type: Application.start_type(),
          args: list,
          result: {:ok, pid()} | {:error, {:already_started, pid()} | {:shutdown, term()} | term()}
  def start(_type, _args) do
    config = Application.get_env(:msg_router, MsgRouter.RedisManager)
    hostname = config[:host]
    password = config[:password]
    database = config[:database]
    port = config[:port]
    pool_size =  String.to_integer(config[:pool_size])
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
         id: RedixSupervisor,
         type: :supervisor,
         start: {Supervisor, :start_link, [children_redix, [strategy: :one_for_one] ]}
       },
      %{
        id: MsgGatewayWeb.Endpoint,
        start: {MsgGatewayWeb.Endpoint, :start_link, []}
      },
      %{
        id: MsgGateway.MqManager,
        start: {MsgGateway.MqManager, :start_link, []}
      },
      %{
        id: MsgGatewayInit,
        start: {MsgGatewayInit, :start_link, []}
      }
    ]

    opts = [strategy: :one_for_one, name: MsgGateway.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @spec config_change(changed, new, removed) :: result when
          changed: keyword(),
          new: keyword(),
          removed: [atom()],
          result: :ok
  def config_change(changed, _new, removed) do
    MsgGatewayWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
