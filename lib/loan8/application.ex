defmodule Loan8.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Loan8Web.Telemetry,
      Loan8.Repo,
      {DNSCluster, query: Application.get_env(:loan8, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Loan8.PubSub},
      # Start a worker by calling: Loan8.Worker.start_link(arg)
      # {Loan8.Worker, arg},
      # Start to serve requests, typically the last entry
      Loan8Web.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Loan8.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    Loan8Web.Endpoint.config_change(changed, removed)
    :ok
  end
end
