defmodule Prometheus.Mixfile do
  use Mix.Project

  @project_url "https://github.com/sandboxws/prometheus"

  def project do
    [app: :prometheus,
     version: "0.0.1",
     elixir: "~> 1.2",
     source_url: @project_url,
     homepage_url: @project_url,
     compilers: compilers(Mix.env),
     compilers: compilers(Mix.env),
     elixirc_paths: elixirc_paths(Mix.env),
     description: "Adapter based Elixir sms library." <>
     " Works with Nexmo, in-memory, and test.",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     package: package,
     docs: [main: "readme", extras: ["README.md"]],
     deps: deps]
  end

  defp compilers(_), do: Mix.compilers

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :hackney, :httpoison],
     mod: {Prometheus, []}]
  end

  defp package do
    [
      maintainers: ["Ahmed El.Hussaini"],
      licenses: ["MIT"],
      links: %{"GitHub" => @project_url}
    ]
  end

  defp elixirc_paths(:test), do: elixirc_paths ++ ["test/support"]
  defp elixirc_paths(_), do: elixirc_paths
  defp elixirc_paths, do: ["lib"]

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:plug, "~> 1.2.0"},
      {:ex_machina, "~> 1.0.2", only: :test},
      {:cowboy, "~> 1.0.4", only: [:test, :dev]},
      {:phoenix, "~> 1.2.1", only: :test},
      {:phoenix_html, "~> 2.6.2", only: :test},
      {:excoveralls, "~> 0.5.6", only: :test},
      {:floki, "~> 0.10.1", only: :test},
      {:ex_doc, "~> 0.13.2", only: :dev},
      {:earmark, ">= 0.0.0", only: :dev},
      # {:hackney, "~> 1.6.0"},
      {:httpoison, "~>0.9.0"},
      {:poison, ">= 2.2.0"},
      {:phone, "~> 0.3.6"}
    ]
  end
end
