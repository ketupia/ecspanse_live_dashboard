defmodule EcspanseLiveDashboard.MixProject do
  use Mix.Project

  @name "ECSpanse Live Dashboard"
  @version "0.1.0"
  @description "A Phoenix LiveDashboard page for monitoring ECSpanse"

  def project do
    [
      app: :ecspanse_live_dashboard,
      name: @name,
      description: @description,
      version: @version,
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {EcspanseLiveDashboard.Application, []},
      extra_applications: [:logger]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:ecspanse, "~> 0.8.0"},
      {:phoenix_live_dashboard, "~> 0.8"}
    ]
  end

  defp aliases do
    []
  end
end
