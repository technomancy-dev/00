defmodule Phoenix00.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Phoenix00Web.Telemetry,
      Phoenix00.Repo,
      {Oban, Application.fetch_env!(:phoenix_00, Oban)},
      {DNSCluster, query: Application.get_env(:phoenix_00, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Phoenix00.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Phoenix00.Finch},
      # Start a worker by calling: Phoenix00.Worker.start_link(arg)
      # {Phoenix00.Worker, arg},
      # Start to serve requests, typically the last entry
      Phoenix00Web.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Phoenix00.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    Phoenix00Web.Endpoint.config_change(changed, removed)
    :ok
  end
end
