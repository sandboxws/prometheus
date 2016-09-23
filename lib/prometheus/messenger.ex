defmodule Prometheus.Messenger do
  @cannot_call_directly_error """
  cannot call Prometheus.Messenger directly. Instead implement your own Messenger module with: Prometheus.Messenger, otp_app: :my_app
  """

  require Logger
  alias Prometheus.Messenger
  alias Prometheus.SMS

  defmacro __using__(opts) do
    quote bind_quoted: [opts: opts] do

      @spec deliver_now(SMS.t) :: SMS.t
      def deliver_now(sms, options \\ %{}) do
        config = build_config
        config = Map.merge config, options

        Prometheus.Messenger.deliver_now(config.adapter, sms, config)
      end

      otp_app = Keyword.fetch!(opts, :otp_app)

      defp build_config, do: Prometheus.Messenger.build_config(__MODULE__, unquote(otp_app))
    end
  end

  def deliver_now(_sms) do
    raise @cannot_call_directly_error
  end

  def deliver_now(adapter, sms, config) do
    sms = sms |> validate_and_normalize

    if sms.to == [] do
      debug_unsent(sms)
    else
      debug_sent(sms, adapter)
      adapter.deliver(sms, config)
    end

    sms
  end

  defp debug_sent(sms, adapter) do
    Logger.debug """
    Sending sms with #{inspect adapter}:

    #{inspect sms, limit: :infinity}
    """
  end

  defp debug_unsent(sms) do
    Logger.debug """
    SMS was not sent since recipients is empty

    SMS - #{inspect sms, limit: :infinitey}
    """
  end

  defp validate_and_normalize(sms) do
    sms |> validate# |> normalize_phones
  end

  defp validate(sms) do
    sms
    |> validate_from
    |> validate_recipient
    |> validate_message
  end

  defp validate_from(%SMS{} = sms) do
    if !Map.get(sms, :from) do
      raise Prometheus.NilFromError, sms
    else
      sms
    end
  end

  defp validate_recipient(%SMS{} = sms) do
    if !Map.get(sms, :to) do
      raise Prometheus.NilRecipientError, sms
    else
      sms
    end
  end

  defp validate_message(%SMS{} = sms) do
    if !Map.get(sms, :message) do
      raise Prometheus.NilMessageError, sms
    else
      sms
    end
  end

  defp is_nil_recipient?(nil), do: true
  defp is_nil_recipient?({_, nil}), do: true
  defp is_nil_recipient?([]), do: false
  defp is_nil_recipient?([_|_] = recipients) do
    Enum.all?(recipients, &is_nil_recipient?/1)
  end
  defp is_nil_recipient?(_), do: false

  def build_config(messenger, otp_app) do
    otp_app
    |> Application.fetch_env!(messenger)
    |> Map.new
    |> handle_adapter_config
  end

  defp handle_adapter_config(base_config = %{adapter: adapter}) do
    adapter.handle_config(base_config)
    # |> Map.put_new(:deliver_later_strategy, Prometheus.TaskSupervisorStrategy)
  end
end
