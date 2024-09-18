defmodule ChatCat.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ChatCatWeb.Telemetry,
      ChatCat.Repo,
      {DNSCluster, query: Application.get_env(:chat_cat, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: ChatCat.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: ChatCat.Finch},
      # Start a worker by calling: ChatCat.Worker.start_link(arg)
      # {ChatCat.Worker, arg},
      # Start to serve requests, typically the last entry
      ChatCatWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ChatCat.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ChatCatWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
