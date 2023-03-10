defmodule SmsRouter.RedisManager do
  @moduledoc false

  @spec get(binary) :: map()| list(map()) | {:error, binary}
  def get(key) when is_binary(key), do: command(["GET", key]) |> check_get(key)

  @spec check_get({:ok, nil} | {:ok, map()} | {:error, term()}, term()) :: {:error, :not_found} | map() | list(map()) | {:error, term()}
  defp check_get({:ok, value}, _) when value == nil, do:  {:error, :not_found}
  defp check_get({:ok, value}, _), do: Jason.decode!(value, [keys: :atoms])
  defp check_get({:error, _reason} = err, _key), do: err

  @spec set(binary, term) :: :ok | {:error, binary}
  def set(key, value) when is_binary(key) and value != nil, do: do_set(["SET", key, Jason.encode!(value)])

  @spec do_set(list) :: :ok | {:error, binary}
  defp do_set(params), do: command(params) |> check_set(params)

  @spec check_set({:ok, term} | {:error, term}, term()) :: :ok | {:error, term()}
  defp check_set({:ok, _}, _), do: :ok
  defp check_set({:error, _reason}, _params), do: :error

  @spec keys(key) :: result when key: String.t(), result: {:ok, [String.t()]}
  def keys(key) when is_binary(key) do
    case command(["KEYS", key]) do
      {:ok, values} -> {:ok, values}
      error ->  error
    end
  end

  @spec del(binary) :: {:ok, non_neg_integer} | {:error, binary}
  def del(key) when is_binary(key), do:  command(["DEL", key]) |> check_del()

  @spec check_del({:ok, term} | term()) :: {:ok, term()} | term()
  defp check_del({:ok, n}) when n >= 1, do: {:ok, n}
  defp check_del(err), do: err

  @spec command(list) :: {:ok, term} | {:error, term}
  defp command(command) when is_list(command) do
    pool_size = String.to_integer(Application.get_env(:sms_router, SmsRouter.RedisManager)[:pool_size])
    connection_index = rem(System.unique_integer([:positive]), pool_size)
    Redix.command(:"redis_#{connection_index}", command)
  end
end
