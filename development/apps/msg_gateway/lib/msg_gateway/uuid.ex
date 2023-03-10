defmodule MsgGateway.UUID do
  @moduledoc false

  @spec generate_uuid() :: result when result: {:ok, String.t()}
  def generate_uuid do
    <<u0::48, _::4, u1::12, _::2, u2::62>> = :crypto.strong_rand_bytes(16)
    string_uuid = bytes_to_string(<<u0::48, 4::4, u1::12, 2::2, u2::62>>)
    {:ok, string_uuid}
  end

  @spec bytes_to_string(byte) :: result when byte: <<_::128>>, result: String.t()
  defp bytes_to_string(<<u1::32, u2::16, u3::16, u4::16, u5::48>>) do
    [el5, el4, el3, el2, el1] = binary_data_to_list([<<u1::32>>, <<u2 ::16>>, <<u3::16>>, <<u4::16>>, <<u5::48>>], [])
    el1 <> "-" <> el2 <> "-" <> el3 <> "-"  <> el4 <> "-" <> el5
  end

  @spec binary_data_to_list(data, acc) :: result when data: [binary()] | [], acc: [] | [String.t()], result: [String.t()]
  defp binary_data_to_list([], acc), do: acc
  defp binary_data_to_list([head | tail], acc) do
    new_el =
      :binary.bin_to_list(head)
      |> list_to_hex_str()
      |> List.to_string

    binary_data_to_list(tail, [new_el|acc])
  end

  @spec list_to_hex_str(data) :: result when data: [integer()]| [], result: [integer()] | []
  defp list_to_hex_str([]), do: []
  defp list_to_hex_str([head | tail]), do: to_hex_str(head) ++ list_to_hex_str(tail)

  @spec to_hex_str(hex) :: result when hex: byte(), result: [integer()]
  defp to_hex_str(n) when n < 256, do: [to_hex(div(n, 16)), to_hex(rem(n, 16))]

  @spec to_hex(int) :: result when int: integer(), result: integer()
  defp to_hex(i) when i < 10, do: 0 + i + 48
  defp to_hex(i) when i >= 10 and i < 16, do: ?a + (i - 10)
end
