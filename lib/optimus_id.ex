defmodule OptimusId do
  @moduledoc """
  """

  use Bitwise, skip_operators: true

  @max_32bit_number 4_294_967_295

  @doc """
  Encodes given message value using provided `OptimusStruct`.

  ## Examples
      iex> s = %OptimusId.OptimusStruct{
      ...>   inverse_prime: 3303820997,
      ...>   prime: 13,
      ...>   xor_modifier: 1310860514
      ...> }
      ...> OptimusId.encode(s, 17)
      1310860351
  """
  def encode(%{prime: prime, xor_modifier: xm}, msg) do
    (msg * prime)
    |> band(@max_32bit_number)
    |> bxor(xm)
  end

  @doc """
  Decodes given cryptogram value using provided `OptimusStruct`.

  ## Examples
      iex> s = %OptimusId.OptimusStruct{
      ...>   inverse_prime: 3303820997,
      ...>   prime: 13,
      ...>   xor_modifier: 1310860514
      ...> }
      ...> OptimusId.decode(s, 1310860351)
      17
  """
  def decode(%{inverse_prime: prime, xor_modifier: xm}, cryptogram) do
    (bxor(cryptogram, xm) * prime)
    |> band(@max_32bit_number)
  end
end
