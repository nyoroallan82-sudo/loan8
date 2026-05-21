defmodule Loan8.FinanceFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Loan8.Finance` context.
  """

  @doc """
  Generate a loan.
  """
  def loan_fixture(attrs \\ %{}) do
    {:ok, loan} =
      attrs
      |> Enum.into(%{
        amount: 42,
        description: "some description",
        interest_rate: 120.5,
        months: 42
      })
      |> Loan8.Finance.create_loan()

    loan
  end
end
