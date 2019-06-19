defmodule OptimusId.SecretTest do
  use ExUnit.Case, async: true

  doctest OptimusId.Secret

  test "generate/1" do
    assert {_, _, _} = OptimusId.Secret.generate(1)
  end
end
