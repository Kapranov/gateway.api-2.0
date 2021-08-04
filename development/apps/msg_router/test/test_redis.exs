defmodule TestRedis do
  @moduledoc false

  @pool_size 5

  def start do
    run("echo 'daemonize yes\npidfile #{pid_file_path()}\nport #{port()}' | redis-server -")
    System.at_exit(&TestRedis.stop/1)
  end

  def stop(_exit_code) do
    {:ok, pid} = File.read(pid_file_path())
    run("kill -9 #{pid}")
  end

  def command(command) do
    Redix.command(:"redix_#{random_index()}", command)
  end

  defp run(cmd) do
    cmd
    |> String.to_charlist
    |> :os.cmd
  end

  defp port(), do: 6395
  defp pid_file_path(), do: "/tmp/redis_test.pid"

  defp random_index() do
    Enum.random(0..@pool_size - 1)
  end
end
