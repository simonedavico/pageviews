defmodule MarkoPageviewsWeb.Tracking.Monitor do
  @moduledoc """
  Monitors LiveViews, timing how long users engage with them
  """

  use GenServer

  require Logger

  alias MarkoPageviews.Tracking
  alias MarkoPageviewsWeb.Tracking.MonitorEntry

  @spec pause :: :ok
  def pause do
    GenServer.cast(__MODULE__, {:pause, self()})
  end

  @spec resume :: :ok
  def resume do
    GenServer.cast(__MODULE__, {:resume, self()})
  end

  @spec monitor(view_module :: atom(), session_id :: String.t(), path :: String.t()) :: :ok
  def monitor(view_module, session_id, path) do
    GenServer.call(__MODULE__, {:monitor, self(), Atom.to_string(view_module), session_id, path})
  end

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl GenServer
  def init(_opts) do
    {:ok, %{}}
  end

  # TODO: pass track_from as param, for more precise tracking
  # after doing so, this can become a handle_cast
  @impl GenServer
  def handle_call(
        {:monitor, pid, view_module, session_id, path},
        _,
        state
      ) do
    Process.monitor(pid)

    Logger.debug(fn -> "Monitoring #{path} (pid #{inspect(pid)}) for session #{session_id}" end)

    {:reply, :ok,
     Map.put(state, pid, %MonitorEntry{
       view_module: view_module,
       track_from: DateTime.utc_now(),
       session_id: session_id,
       path: path,
       started_at: DateTime.utc_now()
     })}
  end

  # TODO: send pause timestamp as param
  @impl GenServer
  def handle_cast({:pause, pid}, state) do
    entry = Map.get(state, pid)

    Logger.debug(fn -> "Pause monitoring for pid #{inspect(pid)} (path #{entry.path})" end)

    {:noreply, Map.put(state, pid, MonitorEntry.pause(entry, DateTime.utc_now()))}
  end

  # TODO: send resume timestamp as param
  @impl GenServer
  def handle_cast({:resume, pid}, state) do
    entry = Map.get(state, pid)

    Logger.debug(fn -> "Resume monitoring for pid #{inspect(pid)} (path #{entry.path})" end)

    {:noreply, Map.put(state, pid, MonitorEntry.resume(entry, DateTime.utc_now()))}
  end

  @impl GenServer
  def handle_info({:DOWN, _ref, :process, pid, _reason}, state) do
    {entry, new_state} = Map.pop(state, pid)

    Logger.debug(fn ->
      "LiveView with pid #{inspect(pid)} (path #{entry.path}) down, tracking pageview"
    end)

    entry
    |> MonitorEntry.stop(DateTime.utc_now())
    |> Map.from_struct()
    |> Tracking.track_pageview()

    {:noreply, new_state}
  end
end
