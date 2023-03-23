defmodule MarkoPageviewsWeb.Tracking.MonitorEntry do
  @moduledoc """
  Helper struct holding state for a pageview in the MarkoPageviewsWeb.Tracking.Monitor
  process.
  """

  defstruct [
    :view_module,
    :track_from,
    :session_id,
    :path,
    :started_at,
    :ended_at,
    engagement_time: 0
  ]

  @type t :: %__MODULE__{
          view_module: String.t(),
          track_from: DateTime.t() | nil,
          session_id: String.t(),
          path: String.t(),
          started_at: DateTime.t(),
          ended_at: DateTime.t() | nil,
          engagement_time: integer()
        }

  @spec pause(entry :: __MODULE__.t(), paused_at :: DateTime.t()) :: __MODULE__.t()
  def pause(%__MODULE__{} = entry, paused_at) do
    engagement_time = entry.engagement_time + DateTime.diff(paused_at, entry.track_from)
    %{entry | engagement_time: engagement_time, track_from: nil}
  end

  @spec resume(entry :: __MODULE__.t(), resumed_at :: DateTime.t()) :: __MODULE__.t()
  def resume(%__MODULE__{} = entry, resumed_at) do
    %{entry | track_from: resumed_at}
  end

  @spec stop(entry :: __MODULE__.t(), stopped_at :: DateTime.t()) :: __MODULE__.t()
  def stop(%__MODULE__{} = entry, stopped_at) do
    engagement_time = entry.engagement_time + DateTime.diff(stopped_at, entry.track_from)
    %{entry | engagement_time: engagement_time, track_from: nil, ended_at: stopped_at}
  end
end
