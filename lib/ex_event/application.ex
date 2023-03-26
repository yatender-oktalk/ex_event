defmodule ExEvent.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      ExEvent.Repo,
      # Start the Telemetry supervisor
      ExEventWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: ExEvent.PubSub},
      # Start the Endpoint (http/https)
      ExEventWeb.Endpoint
      # Start a worker by calling: ExEvent.Worker.start_link(arg)
      # {ExEvent.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ExEvent.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ExEventWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
