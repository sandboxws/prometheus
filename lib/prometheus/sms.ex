defmodule Prometheus.SMS do
  @type phone :: String.t | {String.t, String.t}
  @type phone_list :: nil | phone | [phone] | any

  @type t :: %__MODULE__{
    from: String.t,
    to: phone_list,
    message: String.t,
    headers: %{String.t => String.t},
    assigns: %{atom => any},
    private: %{atom => any}
  }

  defstruct from: nil,
    to: nil,
    message: nil,
    headers: %{},
    assigns: %{},
    private: %{}

  alias Prometheus.SMS

  @phone_functions ~w(from to)a
  @attribute_pipe_functions ~w(message)a

  @doc """
  Used to create a new SMS

  If called without arguments it is the same as creating an empty
  `%Prometheus.SMS{}` struct. If called with arguments it will populate the struct
  with given attributes.

  ## Example

      # Same as %Prometheus.SMS{from: "MyCompany.com"}
      new_sms(from: "MyCompany.com")
  """
  @spec new_sms(Enum.t) :: __MODULE__.t
  def new_sms(attrs \\ []) do
    struct!(%__MODULE__{}, attrs)
  end

  for function_name <- @phone_functions do
    @doc """
    Sets the `#{function_name}` on the sms.

    You can pass in a string, list of strings,
    or anything that implements the `Prometheus.Formatter` protocol.

        new_sms
        |> #{function_name}(["sally@example.com", "james@example.com"])
    """
    @spec unquote(function_name)(__MODULE__.t, phone_list) :: __MODULE__.t
    def unquote(function_name)(sms, attr) do
      Map.put(sms, unquote(function_name), attr)
    end
  end

  for function_name <- @attribute_pipe_functions do
    @doc """
    Sets the #{function_name} on the sms
    """
    def unquote(function_name)(sms, attr) do
      Map.put(sms, unquote(function_name), attr)
    end
  end
end
