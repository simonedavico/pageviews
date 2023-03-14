defmodule MarkoPageviews.Repo do
  use Ecto.Repo,
    otp_app: :marko_pageviews,
    adapter: Ecto.Adapters.Postgres
end
