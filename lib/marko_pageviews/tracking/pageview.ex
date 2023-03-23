defmodule MarkoPageviews.Tracking.PageView do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  alias Ecto.UUID

  @timestamps_opts [type: :utc_datetime_usec]

  @type t :: %__MODULE__{
          id: integer(),
          session_id: UUID.t(),
          view_module: String.t(),
          started_at: DateTime.t(),
          ended_at: DateTime.t(),
          engagement_time: integer(),
          path: String.t(),
          inserted_at: DateTime.t(),
          updated_at: DateTime.t()
        }

  schema "pageviews" do
    field(:session_id, UUID)
    field(:view_module, :string)
    field(:started_at, :utc_datetime)
    field(:ended_at, :utc_datetime)
    field(:engagement_time, :integer, default: 0)
    field(:path, :string)

    timestamps()
  end

  def changeset(pageview \\ %__MODULE__{}, attrs) do
    # add validations here, e.g
    # engagement_time should be nonnegative
    # ended_at - started_at should be positive
    cast(pageview, attrs, [
      :session_id,
      :view_module,
      :started_at,
      :ended_at,
      :engagement_time,
      :path
    ])
  end
end
