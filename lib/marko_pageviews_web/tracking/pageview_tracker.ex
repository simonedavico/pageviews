defmodule MarkoPageviewsWeb.Tracking.PageviewTracker do
  @moduledoc """
  Behaviour for a pageview tracker.
  """

  @callback monitor(
              view_module :: atom(),
              session_id :: String.t(),
              path :: String.t()
            ) :: :ok
  @callback monitor(
              view_module :: atom(),
              session_id :: String.t(),
              path :: String.t(),
              pid :: pid()
            ) :: :ok

  @callback pause(paused_at :: DateTime.t()) :: :ok
  @callback pause(paused_at :: DateTime.t(), pid :: pid()) :: :ok

  @callback resume(resumed_at :: DateTime.t()) :: :ok
  @callback resume(resumed_at :: DateTime.t(), pid :: pid()) :: :ok
end
