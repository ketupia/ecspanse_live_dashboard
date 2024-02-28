defmodule EcspanseLiveDashboard.MixProject do
  use Mix.Project

  @name "Ecspanse Live Dashboard"
  @version "0.1.0"
  @description "A Phoenix LiveDashboard page for inspecting Ecspanse"

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
      # {:phoenix, "~> 1.7.10"},
      # {:phoenix_ecto, "~> 4.4"},
      # {:ecto_sql, "~> 3.10"},
      # {:postgrex, ">= 0.0.0"},
      # {:phoenix_html, "~> 3.3"},
      # {:phoenix_live_reload, "~> 1.2", only: :dev},
      # {:phoenix_live_view, "~> 0.20.1"},
      # {:floki, ">= 0.30.0", only: :test},
      # {:phoenix_live_dashboard, "~> 0.8.2"},
      # {:esbuild, "~> 0.8", runtime: Mix.env() == :dev},
      # {:tailwind, "~> 0.2.0", runtime: Mix.env() == :dev},
      # {:swoosh, "~> 1.3"},
      # {:finch, "~> 0.13"},
      # {:telemetry_metrics, "~> 0.6"},
      # {:telemetry_poller, "~> 1.0"},
      # {:gettext, "~> 0.20"},
      # {:jason, "~> 1.2"},
      # {:dns_cluster, "~> 0.1.1"},
      # {:plug_cowboy, "~> 2.5"}
    ]
  end

  defp aliases do
    []
  end
end
