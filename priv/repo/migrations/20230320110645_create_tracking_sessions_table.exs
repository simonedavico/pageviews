defmodule MarkoPageviews.Repo.Migrations.CreateTrackingSessionsTable do
  use Ecto.Migration

  def change do
    create table(:tracking_sessions) do
      add(:session_id, :uuid, null: false)
      add(:user_agent, :text, null: false)

      timestamps(type: :utc_datetime_usec)
    end
  end
end
