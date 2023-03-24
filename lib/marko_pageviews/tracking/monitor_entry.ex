defmodule MarkoPageviews.Tracking.MonitorEntry do
  @moduledoc """
  Helper struct holding state for a pageview
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
end
