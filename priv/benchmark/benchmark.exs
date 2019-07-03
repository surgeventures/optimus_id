time = fn func ->
  start_at = DateTime.utc_now()
  ret_val = func.()
  end_at = DateTime.utc_now()
  duration = DateTime.diff(end_at, start_at, :microsecond)

  {ret_val, duration}
end

run = fn input, encode, decode ->
  {encoded, encode_duration} = time.(fn -> Enum.map(input, encode) end)
  {encoded_decoded, decode_duration} = time.(fn -> Enum.map(encoded, decode) end)

  unless input == encoded_decoded do
    raise("invalid encode/decode: #{inspect input} != #{inspect encoded_decoded}")
  end

  {encode_duration, decode_duration}
end

run_preload_multi = fn iterations, input, encode, decode ->
  run.(input, encode, decode)

  Enum.reduce(1..iterations, {0, 0}, fn _, {total_encode_duration, total_decode_duration} ->
    {encode_duration, decode_duration} = run.(input, encode, decode)

    {total_encode_duration + encode_duration, total_decode_duration + decode_duration}
  end)
end

input = Enum.to_list(1..1_000)
iterations = 100

# OptimusId

secret = {2078493839, 1968460399, 752744640}
encode = &OptimusId.encode(&1, secret)
decode = &OptimusId.decode(&1, secret)

{encode_duration, decode_duration} = run_preload_multi.(iterations, input, encode, decode)

IO.puts("""
OptimusId

  - encode: #{encode_duration} μs
  - decode: #{decode_duration} μs
""")

if Code.ensure_loaded?(Hashids) do
  # Hashids

  secret = Hashids.new(salt: "123")
  encode = &Hashids.encode(secret, &1)
  decode = fn input -> secret |> Hashids.decode!(input) |> List.first end

  {encode_duration, decode_duration} = run_preload_multi.(iterations, input, encode, decode)

  IO.puts("""
  Hashids

    - encode: #{encode_duration} μs
    - decode: #{decode_duration} μs
  """)
else
  IO.puts("""
  Hashids

    (omitted, please add :hashids to project deps first)
  """)
end
