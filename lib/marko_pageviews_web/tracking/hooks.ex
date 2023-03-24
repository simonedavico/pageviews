defmodule MarkoPageviewsWeb.Tracking.Hooks do
  @moduledoc """
  LiveView hooks for pageview tracking.
  """

  import Phoenix.LiveView

  def on_mount(:default, _params, session, socket) do
    socket =
      attach_hook(
        socket,
        :start_pageview_tracking,
        :handle_params,
        fn _params, uri, socket ->
          if connected?(socket) do
            pageview_tracker().monitor(
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
          "pause", %{"at" => paused_at}, socket ->
            paused_at
            |> DateTime.from_iso8601()
            |> pageview_tracker().pause()

            {:halt, socket}

          "resume", %{"at" => resumed_at}, socket ->
            resumed_at
            |> DateTime.from_iso8601()
            |> pageview_tracker().resume()

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

  defp pageview_tracker do
    Application.get_env(:marko_pageviews, :pageview_tracker)
  end
end
