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

MsgGateway.Plugs.Headers.check_user_status([{_user, {key, true, _, _}}], key_hash, conn)
MsgGateway.Plugs.Headers.check_authorization_keys(_our_key, _key_hash, conn), do: response_error(conn,  @incorrect_key)

```

### 5 August 2021 by Oleg G.Kapranov
