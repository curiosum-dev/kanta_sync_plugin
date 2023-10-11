defmodule Kanta.Sync.Plugin.MixProject do
  use Mix.Project

  def project do
    [
      app: :kanta_sync_plugin,
      description: "Kanta plugin for syncing translations on staging/dev with production",
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:tesla, "~> 1.4"},
      {:jason, "~> 1.4"},
      {:phoenix_live_view, "~> 0.18"},
      {:kanta, path: "../kanta"},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.3", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/curiosum-dev/kanta_sync_plugin"},
      files: ~w(lib LICENSE.md mix.exs README.md)
    ]
  end
end
