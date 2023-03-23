defmodule MarkoPageviews.Repo.Migrations.CreatePageviewsTable do
  use Ecto.Migration

  def change do
    create table(:pageviews) do
      add(:session_id, :uuid, null: false)
      add(:view_module, :text, null: false)
      add(:started_at, :utc_datetime_usec, null: false)
      add(:ended_at, :utc_datetime_usec, null: false)
      add(:engagement_time, :integer, null: false)
      add(:path, :text, null: false)

      timestamps(type: :utc_datetime_usec)
    end
  end
end
