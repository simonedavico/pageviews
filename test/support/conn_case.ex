defmodule MarkoPageviewsWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use MarkoPageviewsWeb.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  defmodule PageviewTrackerStub do
    @moduledoc false
    @behaviour MarkoPageviewsWeb.Tracking.PageviewTracker
    def monitor(_, _, _), do: :ok
    def pause(_), do: :ok
    def resume(_), do: :ok
  end

  using do
    quote do
      # The default endpoint for testing
      @endpoint MarkoPageviewsWeb.Endpoint

      use MarkoPageviewsWeb, :verified_routes

      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import MarkoPageviewsWeb.ConnCase
    end
  end

  setup tags do
    if Map.get(tags, :stub_tracking, true) do
      Mox.stub_with(PageviewTrackerMock, PageviewTrackerStub)
    end

    MarkoPageviews.DataCase.setup_sandbox(tags)
    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
