defmodule Prometheus.LocalAdapter do
  # alias Prometheus.SentSMS

  @behaviour Prometheus.Adapter

  @doc "Adds sms to Prometheus.SentSMS"
  def deliver(sms, _config) do
    IO.puts "Sending local SMS #{inspect sms}"
    # SentSMS.push(sms)
  end

  def handle_config(config), do: config
end
