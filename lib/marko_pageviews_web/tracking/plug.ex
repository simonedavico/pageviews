defmodule MarkoPageviewsWeb.Tracking.Plug do
  @moduledoc """
  A plug to attach a session to a request. If an existing session is not found,
  it creates a new one.
  """

  alias MarkoPageviews.Tracking

  import Plug.Conn

  @max_age 60 * 60 * 24 * 60
  @tracking_session_cookie "_marko_pageviews_web_tracking_session"
  @tracking_session_options [sign: true, max_age: @max_age, same_site: "Lax", http_only: true]

  def track_session(conn, _opts) do
    session_id = read_session_id(conn)
    user_agent = get_user_agent(conn)

    case Tracking.lookup_session(session_id) do
      {:ok, _session} ->
        assign(conn, :session_id, session_id)

      {:error, :not_found} ->
        {:ok, %{session_id: session_id}} = Tracking.create_session(user_agent)

        conn
        |> write_session_id(session_id)
        |> assign(:session_id, session_id)
    end
  end

  defp read_session_id(conn) do
    conn
    |> fetch_cookies(signed: [@tracking_session_cookie])
    |> get_in([Access.key!(:cookies), @tracking_session_cookie])
  end

  defp write_session_id(conn, session_id) do
    put_resp_cookie(conn, @tracking_session_cookie, session_id, @tracking_session_options)
  end

  defp get_user_agent(conn) do
    conn
    |> Plug.Conn.get_req_header("user-agent")
    |> List.first()
    |> UAParser.parse()
    |> to_string()
  end
end
