defmodule OptimusId.MixProject do
  use Mix.Project

  @github_url "https://github.com/surgeventures/optimus_id"
  @description "Obfuscates 32-bit numbers"

  def project do
    [
      app: :optimus_id,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      name: "OptimusId",
      description: @description,
      package: [
        maintainers: ["Karol Słuszniak"],
        licenses: ["MIT"],
        links: %{
          "GitHub" => @github_url
        }
      ],
      docs: [
        main: "OptimusId",
        source_url: @github_url
      ],
      dialyzer: [
        plt_add_apps: [:mix],
        plt_file: {:no_warn, "priv/plts/dialyzer.plt"},
        list_unused_filters: true
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.1.0", only: [:dev], runtime: false},
      {:dialyxir, "~> 0.5.1", only: [:dev], runtime: false},
      {:ex_doc, "~> 0.20.2", only: [:dev], runtime: false}
    ]
  end
end
