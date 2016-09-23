defmodule Prometheus do
  @moduledoc false

  use Application

  defmodule NilRecipientError do
    defexception [:message]

    def exception(sms) do
      message = """
      No recipent was defined.

      SMS - #{inspect sms, limit: :infinity}
      """
      %NilRecipientError{message: message}
    end
  end

  defmodule NilMessageError do
    defexception [:message]

    def exception(sms) do
      message = """
        No SMS message was provided.
      """
      %NilMessageError{message: message}
    end
  end

  defmodule NilFromError do
    defexception [:message]

    def exception(sms) do
      message = """
        From/Sender was not provided.
      """
      %NilFromError{message: message}
    end
  end

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # Define workers and child supervisors to be supervised
      # worker(Prometheus.Worker, [arg1, arg2, arg3]),
    ]


    opts = [strategy: :one_for_one, name: Prometheus.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
