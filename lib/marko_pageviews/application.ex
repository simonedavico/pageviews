defmodule MarkoPageviews.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, %{env: env} = _args) do
    children =
      [
        # Start the Telemetry supervisor
        MarkoPageviewsWeb.Telemetry,
        # Start the Ecto repository
        MarkoPageviews.Repo,
        # Start the PubSub system
        {Phoenix.PubSub, name: MarkoPageviews.PubSub},
        # Start Finch
        {Finch, name: MarkoPageviews.Finch},
        # Start the Endpoint (http/https)
        MarkoPageviewsWeb.Endpoint
        # Start a worker by calling: MarkoPageviews.Worker.start_link(arg)
        # {MarkoPageviews.Worker, arg}
      ] ++ supervisors(env)

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MarkoPageviews.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MarkoPageviewsWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp supervisors(_), do: [MarkoPageviewsWeb.Tracking.Supervisor]
end
