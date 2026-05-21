defmodule Loan8.Finance.Loan do
  use Ecto.Schema
  import Ecto.Changeset

  schema "loans" do
    field :amount, :integer
    field :interest_rate, :float
    field :months, :integer
    field :description, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(loan, attrs) do
    loan
    |> cast(attrs, [:amount, :interest_rate, :months, :description])
    |> validate_required([:amount, :interest_rate, :months, :description])
  end
end
