defmodule OptimusId do
  @moduledoc """
  Obfuscates 32-bit numbers.

  Transform your internal ids to obfuscated integers. Similar to [Hashids](https://hashids.org/),
  although around 1000x faster (see the `priv/benchmark/benchmark.exs`).

  Elixir implementation is compatible with [PHP
  implementation](https://github.com/jenssegers/optimus).

  ## Usage

  In order to encode/decode anything, you'll first have to fetch yourself the `OptimusId.Secret`
  tuple. That's the mystic 2nd argument to `encode/2` and `decode/2` that you'll see in the examples
  below.

  Now, let's start by encoding:

  ```
  iex> OptimusId.encode(17, {2078493839, 1968460399, 2327522479})
  2963487184
  ```

  Our internal identifier (`17`) was transformed into obfuscated identifier (`2963487184`) which is
  safe to be made public.

  In order to recover original identifier we have to call `decode` function:

  ```
  iex> OptimusId.decode(2963487184, {2078493839, 1968460399, 2327522479})
  17
  ```
  """

  use Bitwise, skip_operators: true
  alias OptimusId.Secret

  @max_32bit_number 4_294_967_295

  @type integer_32bit :: 1..4_294_967_295

  @doc """
  Encodes given message value using provided `OptimusId.Secret` tuple.

  ## Examples

      iex> OptimusId.encode(17, {2078493839, 1968460399, 2327522479})
      2963487184

  """
  @spec encode(integer_32bit, Secret.t()) :: integer_32bit
  def encode(message, secret)

  def encode(message, {prime, _, xm}) do
    (message * prime)
    |> band(@max_32bit_number)
    |> bxor(xm)
  end

  @doc """
  Decodes given cryptogram value using provided `OptimusId.Secret` tuple.

  ## Examples

      iex> OptimusId.decode(2963487184, {2078493839, 1968460399, 2327522479})
      17

  """
  @spec decode(integer_32bit, Secret.t()) :: integer_32bit
  def decode(cryptogram, secret)

  def decode(cryptogram, {_, prime, xm}) do
    (bxor(cryptogram, xm) * prime)
    |> band(@max_32bit_number)
  end
end
