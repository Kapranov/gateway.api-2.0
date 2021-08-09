# MsgGateway

```
bash> mix phx.new msg_gateway --no-webpack --no-ecto --no-html --no-gettext --no-dashboard
```

# Attention need Check it out forced their way and will fixed

```
MsgGateway.RedisManager.del([])
MsgGateway.RedisManager.del([1,2,3])
MsgGateway.RedisManager.del("hello")

MsgGateway.MqManager.handle_call({:publish, message}, _, %{chan: chan, connected: true, queue_name: queue_name} = state)
GenServer.cast(MgLogger.Server, {:log, @name, %{:message_id => "message_id", status: "add_to_queue"}})

```

### 5 August 2021 by Oleg G.Kapranov
