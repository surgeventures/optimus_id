defmodule Mix.Tasks.OptimusId.Gen.SecretTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  alias Mix.Tasks.OptimusId.Gen.Secret, as: Task

  test "run/1" do
    output =
      capture_io(fn ->
        Task.run(["1"])
      end)

    assert String.contains?(output, "Generated secret tuple:")
  end
end
