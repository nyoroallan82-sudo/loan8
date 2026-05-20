defmodule Loan8.Repo do
  use Ecto.Repo,
    otp_app: :loan8,
    adapter: Ecto.Adapters.Postgres
end
