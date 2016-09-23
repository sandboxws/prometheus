# Prometheus

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add prometheus to your list of dependencies in `mix.exs`:

        def deps do
          [{:prometheus, "~> 0.0.1"}]
        end

  2. Ensure prometheus is started before your application:

        def application do
          [applications: [:prometheus]]
        end

