defmodule Loan8.FinanceTest do
  use Loan8.DataCase

  alias Loan8.Finance

  describe "loans" do
    alias Loan8.Finance.Loan

    import Loan8.FinanceFixtures

    @invalid_attrs %{description: nil, amount: nil, interest_rate: nil, months: nil}

    test "list_loans/0 returns all loans" do
      loan = loan_fixture()
      assert Finance.list_loans() == [loan]
    end

    test "get_loan!/1 returns the loan with given id" do
      loan = loan_fixture()
      assert Finance.get_loan!(loan.id) == loan
    end

    test "create_loan/1 with valid data creates a loan" do
      valid_attrs = %{description: "some description", amount: 42, interest_rate: 120.5, months: 42}

      assert {:ok, %Loan{} = loan} = Finance.create_loan(valid_attrs)
      assert loan.description == "some description"
      assert loan.amount == 42
      assert loan.interest_rate == 120.5
      assert loan.months == 42
    end

    test "create_loan/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Finance.create_loan(@invalid_attrs)
    end

    test "update_loan/2 with valid data updates the loan" do
      loan = loan_fixture()
      update_attrs = %{description: "some updated description", amount: 43, interest_rate: 456.7, months: 43}

      assert {:ok, %Loan{} = loan} = Finance.update_loan(loan, update_attrs)
      assert loan.description == "some updated description"
      assert loan.amount == 43
      assert loan.interest_rate == 456.7
      assert loan.months == 43
    end

    test "update_loan/2 with invalid data returns error changeset" do
      loan = loan_fixture()
      assert {:error, %Ecto.Changeset{}} = Finance.update_loan(loan, @invalid_attrs)
      assert loan == Finance.get_loan!(loan.id)
    end

    test "delete_loan/1 deletes the loan" do
      loan = loan_fixture()
      assert {:ok, %Loan{}} = Finance.delete_loan(loan)
      assert_raise Ecto.NoResultsError, fn -> Finance.get_loan!(loan.id) end
    end

    test "change_loan/1 returns a loan changeset" do
      loan = loan_fixture()
      assert %Ecto.Changeset{} = Finance.change_loan(loan)
    end
  end
end
