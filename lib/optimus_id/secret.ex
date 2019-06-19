defmodule OptimusId.Secret do
  @moduledoc """
  Holds secret & unique data required for encoding and decoding with the library.

  ## Usage

  Start by generating the secret (choose large prime number that fits in 4-byte integer):

      secret = OptimusId.Secret.generate(2078493839)

  Depending on your application and approach towards security you may choose one of following
  approaches towards storing the newly generated secret:

  - use the tuple representation directly (e.g. if the secret will be hardcoded into source code or
    stored in database with support for Erlang terms like ETS)

  - store string representation yielded by `OptimusId.Secret.to_string/1` and convert it back to
    tuple representation (e.g. if using env vars or arbitrary secret vault)

  > For improved security you may choose to use multiple secrets (e.g. one per API resource).

  """

  @type t_prime :: OptimusId.integer_32bit()
  @type t_inverse_prime :: OptimusId.integer_32bit()
  @type t_xor_modifier :: OptimusId.integer_32bit()

  @type t :: {
          t_prime,
          t_inverse_prime,
          t_xor_modifier
        }

  @max_32bit_number_plus_one 4_294_967_296

  @doc """
  Generates new random secret based on 32-bit prime number.

  Note that generated secret will be different even for the same input prime number.
  """
  @spec generate(OptimusId.integer_32bit()) :: t()
  def generate(prime) do
    inverse_prime = inverse(prime, @max_32bit_number_plus_one)
    xor_modifier = random_xor_modifier()

    {prime, inverse_prime, xor_modifier}
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

  @doc """
  Converts secret tuple to string representation (useful for storage in env var or vault).

  Note that OptimusId doesn't use the string version for performance reasons and since libraries are
  not available in `config/*.exs` you'll have to convert it yourself e.g. with following code in
  `config/releases.exs`:

      secret_string = System.fetch_env!("MY_SECRET")

      secret_tuple =
        secret_string
        |> String.split("-")
        |> Enum.map(&String.to_integer/1)
        |> List.to_tuple

      config :my_app, :my_secret, secret_tuple

  """
  @spec to_string(t) :: String.t()
  def to_string(tuple) do
    tuple
    |> Tuple.to_list()
    |> Enum.join("-")
  end
end
