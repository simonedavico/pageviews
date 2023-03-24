defmodule MarkoPageviewsWeb.Tracking.Monitor do
  @moduledoc """
  Monitors LiveViews, timing how long users engage with them
  """

  use GenServer

  require Logger

  alias MarkoPageviews.Tracking
  alias MarkoPageviewsWeb.Tracking.MonitorEntry

  @spec pause(paused_at :: DateTime.t()) :: :ok
  def pause(paused_at) do
    GenServer.cast(__MODULE__, {:pause, self(), paused_at})
  end

  @spec resume(resumed_at :: DateTime.t()) :: :ok
  def resume(resumed_at) do
    GenServer.cast(__MODULE__, {:resume, self(), resumed_at})
  end

  @spec monitor(view_module :: atom(), session_id :: String.t(), path :: String.t()) :: :ok
  def monitor(view_module, session_id, path) do
    GenServer.call(__MODULE__, {:monitor, self(), view_module, session_id, path})
  end

  def start_link(opts) do
    GenServer.start_link(
      __MODULE__,
      %{
        pageviews: %{},
        on_pageview: Keyword.get(opts, :on_pageview, fn -> nil end)
      },
      name: __MODULE__
    )
  end

  @impl GenServer
  def init(state) do
    {:ok, state}
  end

  @impl GenServer
  def handle_call(
        {:monitor, pid, view_module, session_id, path},
        _,
        %{pageviews: pageviews} = state
      ) do
    Process.monitor(pid)

    Logger.debug(fn -> "Monitoring #{path} (pid #{inspect(pid)}) for session #{session_id}" end)

    {:reply, :ok,
     %{
       state
       | pageviews:
           Map.put(pageviews, pid, Tracking.start_pageview(view_module, session_id, path))
     }}
  end

  @impl GenServer
  def handle_cast({:pause, pid, paused_at}, %{pageviews: pageviews} = state) do
    entry = Map.get(state, pid)

    Logger.debug(fn -> "Pause monitoring for pid #{inspect(pid)} (path #{entry.path})" end)

    {:noreply,
     %{state | pageviews: Map.put(pageviews, pid, Tracking.pause_pageview(entry, paused_at))}}
  end

  @impl GenServer
  def handle_cast({:resume, pid, resumed_at}, %{pageviews: pageviews} = state) do
    entry = Map.get(state, pid)

    Logger.debug(fn -> "Resume monitoring for pid #{inspect(pid)} (path #{entry.path})" end)

    {:noreply,
     %{state | pageviews: Map.put(pageviews, pid, Tracking.resume_pageview(entry, resumed_at))}}
  end

  @impl GenServer
  def handle_info({:DOWN, _ref, :process, pid, _reason}, state) do
    {entry, new_pageviews} = Map.pop(state.pageviews, pid)

    Logger.debug(fn ->
      "LiveView with pid #{inspect(pid)} (path #{entry.path}) down, tracking pageview"
    end)

    {:ok, _} = Tracking.stop_pageview(entry, DateTime.utc_now())

    state.on_pageview.()

    {:noreply, %{state | pageviews: new_pageviews}}
  end
end
