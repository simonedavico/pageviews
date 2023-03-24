defmodule MarkoPageviewsWeb.Tracking.Supervisor do
  @moduledoc false

  use Supervisor

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: TrackingSupervisor)
  end

  @impl Supervisor
  def init(_init_arg) do
    Supervisor.init(children(), strategy: :one_for_one)
  end

  defp children do
    [MarkoPageviewsWeb.Tracking.InMemoryPageviewTracker]
  end
end
