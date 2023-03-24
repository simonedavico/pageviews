defmodule MarkoPageviews.Tracking do
  @moduledoc """
  Tracking context, to perform operations on Sessions and PageViews.
  """

  import Ecto.Query, warn: false

  alias MarkoPageviews.Repo
  alias MarkoPageviews.Tracking.MonitorEntry
  alias MarkoPageviews.Tracking.PageView
  alias MarkoPageviews.Tracking.Session

  @spec create_session(user_agent :: String.t()) ::
          {:ok, Session.t()} | {:error, Ecto.Changeset.t()}
  def create_session(user_agent) do
    # add changeset for Session
    session_id = Ecto.UUID.generate()

    session = %Session{
      user_agent: user_agent,
      session_id: session_id
    }

    Repo.insert(session)
  end

  @spec lookup_session(session_id :: String.t()) :: {:ok, Session.t()} | {:error, :not_found}
  def lookup_session(nil), do: {:error, :not_found}

  def lookup_session(session_id) do
    case Repo.one(from(s in Session, where: s.session_id == ^session_id)) do
      nil -> {:error, :not_found}
      session -> {:ok, session}
    end
  end

  @spec start_pageview(view_module :: atom(), session_id :: String.t(), path :: String.t()) ::
          MonitorEntry.t()
  def start_pageview(view_module, session_id, path) do
    %MonitorEntry{
      view_module: Atom.to_string(view_module),
      track_from: DateTime.utc_now(),
      session_id: session_id,
      path: path,
      started_at: DateTime.utc_now()
    }
  end

  @spec pause_pageview(entry :: MonitorEntry.t(), paused_at :: DateTime.t()) :: MonitorEntry.t()
  def pause_pageview(%MonitorEntry{} = entry, paused_at) do
    engagement_time = entry.engagement_time + DateTime.diff(paused_at, entry.track_from)
    %{entry | engagement_time: engagement_time, track_from: nil}
  end

  @spec resume_pageview(entry :: MonitorEntry.t(), resumed_at :: DateTime.t()) :: MonitorEntry.t()
  def resume_pageview(%MonitorEntry{} = entry, resumed_at) do
    %{entry | track_from: resumed_at}
  end

  @spec stop_pageview(entry :: MonitorEntry.t(), stopped_at :: DateTime.t()) ::
          {:ok, PageView.t()} | {:error, Ecto.Changeset.t()}
  def stop_pageview(%MonitorEntry{} = entry, stopped_at) do
    engagement_time = entry.engagement_time + DateTime.diff(stopped_at, entry.track_from)

    updated_entry = %{
      entry
      | engagement_time: engagement_time,
        track_from: nil,
        ended_at: stopped_at
    }

    %PageView{}
    |> PageView.changeset(Map.from_struct(updated_entry))
    |> Repo.insert()
  end
end
