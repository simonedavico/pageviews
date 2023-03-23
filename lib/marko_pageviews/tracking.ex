defmodule MarkoPageviews.Tracking do
  @moduledoc """
  Tracking context, to perform operations on Sessions and PageViews.
  """

  import Ecto.Query, warn: false

  alias Ecto.UUID
  alias MarkoPageviews.Repo
  alias MarkoPageviews.Tracking.PageView
  alias MarkoPageviews.Tracking.Session

  @spec create_session(user_agent :: String.t()) ::
          {:ok, Session.t()} | {:error, Ecto.Changeset.t()}
  def create_session(user_agent) do
    # TODO: add changeset for Session
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

  @spec track_pageview(attrs :: map()) :: {:ok, PageView.t()} | {:error, Ecto.Changeset.t()}
  def track_pageview(attrs \\ %{}) do
    %PageView{}
    |> PageView.changeset(attrs)
    |> Repo.insert()
  end
end
