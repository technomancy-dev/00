defmodule Phoenix00.Repo do
  use Ecto.Repo,
    otp_app: :phoenix_00,
    adapter: Ecto.Adapters.SQLite3
end
