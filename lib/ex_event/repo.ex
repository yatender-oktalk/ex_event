defmodule ExEvent.Repo do
  use Ecto.Repo,
    otp_app: :ex_event,
    adapter: Ecto.Adapters.Postgres
end
