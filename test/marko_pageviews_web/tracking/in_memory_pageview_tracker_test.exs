defmodule MarkoPageviewsWeb.Tracking.InMemoryPageviewTrackerTest do
  use MarkoPageviewsWeb.ConnCase, async: false

  alias MarkoPageviews.Repo
  alias MarkoPageviews.Tracking.PageView
  alias MarkoPageviewsWeb.Tracking.InMemoryPageviewTracker

  defmodule GenServerStub do
    use GenServer

    def init(state) do
      {:ok, state}
    end

    def start do
      GenServer.start(__MODULE__, [])
    end
  end

  test "should track a pageview when the monitored process dies" do
    uid = make_ref()
    test_pid = self()
    session_id = Ecto.UUID.generate()

    _ =
      start_supervised!(
        {InMemoryPageviewTracker,
         [
           on_pageview: fn ->
             send(test_pid, {:page_viewed, uid})
           end
         ]}
      )

    {:ok, pid} = GenServerStub.start()

    InMemoryPageviewTracker.monitor(GenServerStub, session_id, "/some-path", pid)

    Process.exit(pid, :kill)

    assert_receive {:page_viewed, ^uid}
    assert 1 == Repo.aggregate(PageView, :count, :id)
  end
end
