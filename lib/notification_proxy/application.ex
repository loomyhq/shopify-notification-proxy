defmodule NotificationProxy.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  alias NotificationProxy.PayoutPoller

  @impl true
  def start(_type, _args) do
    # create an ets table for the payout logging
    PayoutPoller.create_ets_table()

    children = [
      NotificationProxy.Scheduler,
      NotificationProxyWeb.Telemetry,
      {DNSCluster,
       query: Application.get_env(:notification_proxy, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: NotificationProxy.PubSub},
      # Start a worker by calling: NotificationProxy.Worker.start_link(arg)
      # {NotificationProxy.Worker, arg},
      # Start to serve requests, typically the last entry
      NotificationProxyWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: NotificationProxy.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    NotificationProxyWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
