defmodule Mix.Tasks.OptimusId.Gen.Secret do
  @moduledoc """
  Generates secret based on 32-bit prime number and prints it in struct and string form.
  """

  @shortdoc "Generates secret based on 32-bit prime number and prints it as struct & string"

  use Mix.Task

  @impl true
  def run([prime_string]) do
    prime = String.to_integer(prime_string)
    secret = OptimusId.Secret.generate(prime)
    secret_string = OptimusId.Secret.to_string(secret)
    secret_pretty = inspect(secret, pretty: true, syntax_colors: [number: :green, tuple: :cyan])

    IO.puts("""
    Generated secret tuple:

      #{secret_pretty}

    It may be stored in env var or secret vault as following string:

      #{IO.ANSI.green()}#{secret_string}#{IO.ANSI.reset()}

    Note that OptimusId doesn't use the string version for performance reasons
    and since libraries are not available in config/*.exs you'll have to convert
    it yourself e.g. with following code in config/releases.exs:

      #{IO.ANSI.cyan()}secret_string = System.fetch_env!("MY_SECRET")

      secret_tuple =
        secret_string
        |> String.split("-")
        |> Enum.map(&String.to_integer/1)
        |> List.to_tuple

      config :my_app, :my_secret, secret_tuple#{IO.ANSI.reset()}
    """)
  end
end
