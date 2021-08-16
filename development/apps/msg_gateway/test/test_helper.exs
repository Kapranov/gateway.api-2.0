os_exclude = if :os.type() == {:unix, :darwin},
  do: [skip_on_mac: true], else: []

{:ok, _} = Application.ensure_all_started(:ex_machina)

ExUnit.configure(exclude: [pending: true],
  formatters: [JUnitFormatter, ExUnit.CLIFormatter, ExUnitNotifier])
ExUnit.start(exclude: [:skip | os_exclude], trace: true)

case :gen_tcp.connect('localhost', 6379, []) do
  {:ok, socket} ->
    :ok = :gen_tcp.close(socket)
  {:error, reason} ->
    Mix.raise("Cannot connect to Redis (http://localhost:6379): #{:inet.format_error(reason)}")
end

Application.ensure_started(:amqp) 
