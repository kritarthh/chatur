defmodule Chatur.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    Startup.make_links()

    children = [
      # Start the Ecto repository
      # Chatur.Repo,
      # Start the Telemetry supervisor
      ChaturWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Chatur.PubSub},
      # Start the Endpoint (http/https)
      ChaturWeb.Endpoint,
      # Start a worker by calling: Chatur.Worker.start_link(arg)
      # {Chatur.Worker, arg}
      {InputPort, name: InputPort},
      {Location, name: Location},
      {LogReader, name: LogReader},
      {LogDispatcher, name: LogDispatcher},
      {Player, name: Player},
      {Movement, name: Movement},
      {Chat, name: Chat},
      {DynamicSupervisor, strategy: :one_for_one, name: Nades}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Chatur.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ChaturWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
