defmodule MedussaStudio.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      MedussaStudioWeb.Telemetry,
      MedussaStudio.Repo,
      {DNSCluster, query: Application.get_env(:medussa_studio, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: MedussaStudio.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: MedussaStudio.Finch},
      # Start a worker by calling: MedussaStudio.Worker.start_link(arg)
      # {MedussaStudio.Worker, arg},
      # Start to serve requests, typically the last entry
      MedussaStudioWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MedussaStudio.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MedussaStudioWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
