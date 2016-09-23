defmodule Prometheus.NexmoAdapter do
  @default_base_uri "https://rest.nexmo.com"
  @send_message_path "/sms/json?"
  @behaviour Prometheus.Adapter

  alias Prometheus.SMS

  defmodule ApiError do
    defexception [:message]

    def exception(%{message: message}) do
      %ApiError{message: message}
    end

    def exception(%{params: params, response: response}) do
      filtered_params = params |> Plug.Conn.Query.decode |> Map.put("key", "[FILTERED]")

      message = """
      There was a problem sending the sms through the Nexmo API.

      Here is the response from Nexmo:

      #{inspect response, limit: :infinity}

      Here are the params sent to Nexmo:

      #{inspect filtered_params, limit: :infinity}
      """

      %ApiError{message: message}
    end
  end

  def deliver(sms, config) do
    api_key = get_key(config)
    api_secret = get_secret(config)

    body = sms |> to_nexmo_body
    body = Map.put(body, :api_key, api_key)
    body = Map.put(body, :api_secret, api_secret)
    if config[:lang] == :arabic do
      body = Map.put(body, :type, "unicode")
    end
    body = body |> Plug.Conn.Query.encode

    url = base_uri <> @send_message_path <> body

    case HTTPoison.get(url) do
      {:ok, response} ->
        %{status_code: response.status_code, headers: response.headers, body: response.body}
      {:error, reason} ->
        raise(ApiError, %{message: inspect(reason)})
    end
  end

  @doc false
  def handle_config(config) do
    if config[:api_secret] in [nil, ""] do
      raise_api_secret_error(config)
    else
      config
    end
  end

  defp get_key(config) do
    case Map.get(config, :api_key) do
      key -> key
    end
  end

  defp get_secret(config) do
    case Map.get(config, :api_secret) do
      nil -> raise_api_secret_error(config)
      secret -> secret
    end
  end

  defp raise_api_secret_error(config) do
    raise ArgumentError, """
    There was no API secret provided for the Nexmo adapter.

    * Here are the config options that were passed in:

    #{inspect config}
    """
  end

  defp to_nexmo_body(%SMS{} = sms) do
    %{}
    |> put_from(sms)
    |> put_to(sms)
    |> put_message(sms)
  end

  defp put_from(body, %SMS{from: from}) do
    Map.put(body, :from, from)
  end

  defp put_to(body, %SMS{to: to}) do
    Map.put(body, :to, to)
  end

  defp put_message(body, %SMS{message: message}) do
    Map.put(body, :text, message)
  end

  defp base_uri do
    Application.get_env(:prometheus, :nexmo_base_uri) || @default_base_uri
  end
end
