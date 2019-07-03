# OptimusId

[![license](https://img.shields.io/github/license/surgeventures/optimus_id.svg)](https://github.com/surgeventures/optimus_id/blob/master/LICENSE.md)
[![build status](https://img.shields.io/circleci/project/github/surgeventures/optimus_id/master.svg)](https://circleci.com/gh/surgeventures/surgeventures/optimus_id/tree/master)
[![Hex version](https://img.shields.io/hexpm/v/optimus_id.svg)](https://hex.pm/packages/optimus_id)

*Obfuscate 32-bit numbers.*

Transform your internal ids to obfuscated integers. Similar to [Hashids](https://hashids.org/),
although around 1000x faster (see the *Benchmark* section below).

Elixir implementation is compatible with [PHP
implementation](https://github.com/jenssegers/optimus).

## Getting started

### Generate and store the secret

Start by generating the secret (choose large prime number that fits in 4-byte integer):

```
mix optimus_id.gen.secret 2078493839
```

You'll get output similar to following:

```
Generated secret tuple:

  {2078493839, 1968460399, 752744640}

It may be stored in env var or secret vault as following string:

  2078493839-1968460399-752744640
```

Depending on your application and approach towards security you may choose one of following
approaches towards storing the newly generated secret:

- use the tuple representation directly (e.g. if the secret will be hardcoded into source code or
  stored in database with support for Erlang terms like ETS)

- store string representation yielded by `OptimusId.Secret.to_string/1` and convert it back to tuple
  representation (e.g. if using env vars or arbitrary secret vault)

Note that OptimusId doesn't use the string version for performance reasons and since libraries are
not available in `config/*.exs` you'll have to convert it yourself e.g. with following code in
`config/releases.exs`:

```
secret_string = System.fetch_env!("MY_SECRET")

secret_tuple =
  secret_string
  |> String.split("-")
  |> Enum.map(&String.to_integer/1)
  |> List.to_tuple

config :my_app, :my_secret, secret_tuple
```

> For improved security you may choose to use multiple secrets (e.g. one per API resource).

### Encode and decode

Let's start by encoding:

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

## Benchmark

Run benchmark with:

```
mix run priv/benchmark/benchmark.exs
```

If you also add `:hashids` to the project deps, you'll see output like below:

```
OptimusId

- encode: 3979 μs
- decode: 5382 μs

Hashids

- encode: 5430765 μs
- decode: 5472152 μs
```
