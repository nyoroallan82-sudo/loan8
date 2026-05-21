defmodule Loan8.Repo.Migrations.CreateLoans do
  use Ecto.Migration

  def change do
    create table(:loans) do
      add :amount, :integer
      add :interest_rate, :float
      add :months, :integer
      add :description, :string

      timestamps(type: :utc_datetime)
    end
  end
end
