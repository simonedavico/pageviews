defmodule MarkoPageviewsWeb.Tracking.HooksTest do
  use MarkoPageviewsWeb.ConnCase, async: true, stub_tracking: false

  import Phoenix.LiveViewTest
  import Mox

  setup :verify_on_exit!

  test "should attach hooks for session tracking", %{conn: conn} do
    pause_at = DateTime.utc_now()
    resume_at = DateTime.add(DateTime.utc_now(), 2)

    expect(PageviewTrackerMock, :monitor, fn view_module, _session_id, path ->
      assert MarkoPageviewsWeb.PageALive = view_module
      assert "/page_a" = path
      :ok
    end)

    expect(PageviewTrackerMock, :pause, fn at ->
      assert ^pause_at = at
    end)

    expect(PageviewTrackerMock, :resume, fn at ->
      assert ^resume_at = at
      :ok
    end)

    {:ok, view, _html} = live(conn, "/page_a")

    render_hook(view, "pause", %{"at" => DateTime.to_iso8601(pause_at)})
    render_hook(view, "resume", %{"at" => DateTime.to_iso8601(resume_at)})
  end
end
