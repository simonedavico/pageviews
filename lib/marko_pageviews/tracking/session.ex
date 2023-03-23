defmodule MarkoPageviews.Tracking.Session do
  @moduledoc false

  use Ecto.Schema

  alias Ecto.UUID

  @timestamps_opts [type: :utc_datetime_usec]

  @type t :: %__MODULE__{
          id: integer(),
          session_id: UUID.t(),
          user_agent: String.t(),
          inserted_at: DateTime.t(),
          updated_at: DateTime.t()
        }

  schema "tracking_sessions" do
    field(:session_id, UUID)
    field(:user_agent, :string)

    timestamps()
  end
end
