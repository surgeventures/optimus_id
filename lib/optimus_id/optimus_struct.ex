defmodule OptimusId.OptimusStruct do
  defstruct [:prime, :inverse_prime, :xor_modifier]

  @max_32bit_number_plus_one 4_294_967_296

  def new(prime) do
    %__MODULE__{
      prime: prime,
      inverse_prime: inverse(prime, @max_32bit_number_plus_one),
      xor_modifier: random_xor_modifier()
    }
  end

  defp random_xor_modifier do
    Integer.undigits(
      :crypto.strong_rand_bytes(4) |> :binary.bin_to_list(),
      256
    )
  end

  defp inverse(e, et) do
    {g, x} = extended_gcd(e, et)
    if g != 1, do: raise("The maths are broken!")
    rem(x + et, et)
  end

  defp extended_gcd(a, b) do
    {last_remainder, last_x} = extended_gcd(abs(a), abs(b), 1, 0, 0, 1)
    {last_remainder, last_x * if(a < 0, do: -1, else: 1)}
  end

  defp extended_gcd(last_remainder, 0, last_x, _, _, _), do: {last_remainder, last_x}

  defp extended_gcd(last_remainder, remainder, last_x, x, last_y, y) do
    quotient = div(last_remainder, remainder)
    remainder2 = rem(last_remainder, remainder)
    extended_gcd(remainder, remainder2, x, last_x - quotient * x, y, last_y - quotient * y)
  end
end
