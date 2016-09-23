defmodule Prometheus.Adapter do
  @callback deliver(%Prometheus.SMS{}, %{}) :: any
  @callback handle_config(map) :: map
end
