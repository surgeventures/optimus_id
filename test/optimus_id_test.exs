defmodule OptimusIdTest do
  use ExUnit.Case, async: true

  doctest OptimusId

  @secret {2_078_493_839, 1_968_460_399, 752_744_640}

  test "input |> encoded |> decoded equals input for supported input range" do
    encode_decode = fn input ->
      input
      |> Enum.map(&OptimusId.encode(&1, @secret))
      |> Enum.map(&OptimusId.decode(&1, @secret))
    end

    [
      0,
      10_000,
      100_000,
      1_000_000,
      2_000_000,
      4_000_000,
      4_294_967_295 - 1_000
    ]
    |> Enum.map(fn input_start ->
      input = Enum.to_list(input_start..(input_start + 1_000))
      input_after = encode_decode.(input)

      {input, input_after}
    end)
    |> Enum.each(fn {input, input_after} ->
      assert input == input_after
    end)
  end

  test "input |> encoded |> decoded equals input for supported secret prime range" do
    encode_decode = fn input, prime ->
      secret = OptimusId.Secret.generate(prime)

      input
      |> OptimusId.encode(secret)
      |> OptimusId.decode(secret)
    end

    [
      91_577_819,
      401_226_671,
      729_681_829,
      1_678_166_671,
      2_425_561_097,
      3_032_315_339,
      4_005_289_087,
      4_051_814_341
    ]
    |> Enum.map(fn prime ->
      input = 1_000_000_000
      input_after = encode_decode.(input, prime)

      {input, input_after}
    end)
    |> Enum.each(fn {input, input_after} ->
      assert input == input_after
    end)
  end
end
