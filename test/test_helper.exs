Mox.defmock(PageviewTrackerMock, for: MarkoPageviewsWeb.Tracking.PageviewTracker)
Application.put_env(:marko_pageviews, :pageview_tracker, PageviewTrackerMock)

ExUnit.start()

Ecto.Adapters.SQL.Sandbox.mode(MarkoPageviews.Repo, :manual)
