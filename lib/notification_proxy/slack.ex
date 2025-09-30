defmodule NotificationProxy.Slack do
  @moduledoc false

  def post(message) do
    url = Application.get_env(:notification_proxy, :slack_hook)

    params = %{
      text: message
    }

    IO.puts(message)

    HTTPoison.post(url, Jason.encode!(params), [{"Content-Type", "application/json"}])
  end
end
