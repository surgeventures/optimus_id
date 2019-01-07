# OptimusId

*Obfuscate 32-bit numbers.* Transform your internal ids to obfuscated
integers. Similar to [Hashids](https://hashids.org/), although much faster.

Elixir implementation is compatible with [PHP
implementation](https://github.com/jenssegers/optimus).

## Getting started

Start with choosing large prime number that fits in 4-byte integer (for
sake of simplicity examples use much smaller prime numbers). Feed it to the
`OptimusStruct` generator to create structure that is needed for the
obfuscating algorithm.

```
iex(1)> secret = OptimusId.OptimusStruct.new(13)
%OptimusId.OptimusStruct{
  inverse_prime: 3303820997,
  prime: 13,
  xor_modifier: 1324830734
}
```

Generated secret consists of two prime numbers and xor bitmask. This secret
struct is needed both to encrypt and decrypt message.

```
iex(2)> secret |> OptimusId.encode(123)
2305684427
```

Our internal identifier (`123`) was transformed into obfuscated identifier
(`2305684427`) which is safe to be made public.

In order to recover original identifier we have to call `decode` function:

```
iex(3)> secret |> OptimusId.decode(2305684427)
123
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `optimus_id` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:optimus_id, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/optimus_id](https://hexdocs.pm/optimus_id).

