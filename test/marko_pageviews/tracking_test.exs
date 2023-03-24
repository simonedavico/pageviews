defmodule MarkoPageviews.TrackingTest do
  use MarkoPageviews.DataCase, async: true

  alias MarkoPageviews.Tracking
  alias MarkoPageviews.Tracking.PageView
  alias MarkoPageviews.Repo

  describe "pageview tracking" do
    test "should snapshot engagement time on pause" do
      session_id = Ecto.UUID.generate()
      start_time = DateTime.utc_now()
      after_five_seconds = time_after(start_time, 5)

      monitor =
        :view_module
        |> Tracking.start_pageview(session_id, "/view_path")
        |> Tracking.pause_pageview(after_five_seconds)

      assert 5 = monitor.engagement_time
    end

    test "should start measuring again on resume" do
      session_id = Ecto.UUID.generate()

      start_time = DateTime.utc_now()
      after_five_seconds = time_after(start_time, 5)
      after_ten_seconds = time_after(start_time, 10)
      after_twelve_seconds = time_after(start_time, 12)

      monitor =
        :view_module
        |> Tracking.start_pageview(session_id, "/view_path")
        |> Tracking.pause_pageview(after_five_seconds)
        |> Tracking.resume_pageview(after_ten_seconds)

      assert 5 = monitor.engagement_time
      assert ^after_ten_seconds = monitor.track_from

      monitor = Tracking.pause_pageview(monitor, after_twelve_seconds)

      assert 7 = monitor.engagement_time
    end

    test "should store pageview" do
      session_id = Ecto.UUID.generate()
      start_time = DateTime.truncate(DateTime.utc_now(), :second)

      after_five_seconds = time_after(start_time, 5)

      {:ok, pageview} =
        :view_module
        |> Tracking.start_pageview(session_id, "/view_path")
        |> Tracking.stop_pageview(after_five_seconds)

      assert 1 == Repo.aggregate(PageView, :count, :id)
      assert ^after_five_seconds = DateTime.truncate(pageview.ended_at, :second)
      assert ^start_time = pageview.started_at
      assert 5 = pageview.engagement_time
    end
  end

  defp time_after(time, amount, unit \\ :second) do
    time
    |> DateTime.add(amount, unit)
    |> DateTime.truncate(:second)
  end
end
