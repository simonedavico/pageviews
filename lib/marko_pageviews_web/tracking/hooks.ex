defmodule MarkoPageviewsWeb.Tracking.Hooks do
  @moduledoc """
  LiveView hooks for pageview tracking.
  """

  import Phoenix.LiveView

  alias MarkoPageviewsWeb.Tracking.Monitor

  def on_mount(:default, _params, session, socket) do
    socket =
      attach_hook(
        socket,
        :start_pageview_tracking,
        :handle_params,
        fn _params, uri, socket ->
          if connected?(socket) do
            Monitor.monitor(
              socket.view,
              session["tracking_session_id"],
              URI.parse(uri).path
            )
          end

          {:cont, socket}
        end
      )

    socket =
      attach_hook(
        socket,
        :pause_resume_pageview_tracking,
        :handle_event,
        fn
          "pause", _params, socket ->
            Monitor.pause()
            {:halt, socket}

          "resume", _params, socket ->
            Monitor.resume()
            {:halt, socket}

          _event, _params, socket ->
            {:cont, socket}
        end
      )

    {:cont, socket}
  end

  def session(conn) do
    %{"tracking_session_id" => conn.assigns.session_id}
  end
end
