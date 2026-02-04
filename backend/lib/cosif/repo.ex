defmodule Cosif.Repo do
  use Ecto.Repo,
    otp_app: :cosif,
    adapter: Ecto.Adapters.Postgres
end
