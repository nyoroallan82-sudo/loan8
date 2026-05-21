defmodule Loan8Web.LoanLiveTest do
  use Loan8Web.ConnCase

  import Phoenix.LiveViewTest
  import Loan8.FinanceFixtures

  @create_attrs %{description: "some description", amount: 42, interest_rate: 120.5, months: 42}
  @update_attrs %{description: "some updated description", amount: 43, interest_rate: 456.7, months: 43}
  @invalid_attrs %{description: nil, amount: nil, interest_rate: nil, months: nil}
  defp create_loan(_) do
    loan = loan_fixture()

    %{loan: loan}
  end

  describe "Index" do
    setup [:create_loan]

    test "lists all loans", %{conn: conn, loan: loan} do
      {:ok, _index_live, html} = live(conn, ~p"/loans")

      assert html =~ "Listing Loans"
      assert html =~ loan.description
    end

    test "saves new loan", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/loans")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New Loan")
               |> render_click()
               |> follow_redirect(conn, ~p"/loans/new")

      assert render(form_live) =~ "New Loan"

      assert form_live
             |> form("#loan-form", loan: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#loan-form", loan: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/loans")

      html = render(index_live)
      assert html =~ "Loan created successfully"
      assert html =~ "some description"
    end

    test "updates loan in listing", %{conn: conn, loan: loan} do
      {:ok, index_live, _html} = live(conn, ~p"/loans")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#loans-#{loan.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/loans/#{loan}/edit")

      assert render(form_live) =~ "Edit Loan"

      assert form_live
             |> form("#loan-form", loan: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#loan-form", loan: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/loans")

      html = render(index_live)
      assert html =~ "Loan updated successfully"
      assert html =~ "some updated description"
    end

    test "deletes loan in listing", %{conn: conn, loan: loan} do
      {:ok, index_live, _html} = live(conn, ~p"/loans")

      assert index_live |> element("#loans-#{loan.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#loans-#{loan.id}")
    end
  end

  describe "Show" do
    setup [:create_loan]

    test "displays loan", %{conn: conn, loan: loan} do
      {:ok, _show_live, html} = live(conn, ~p"/loans/#{loan}")

      assert html =~ "Show Loan"
      assert html =~ loan.description
    end

    test "updates loan and returns to show", %{conn: conn, loan: loan} do
      {:ok, show_live, _html} = live(conn, ~p"/loans/#{loan}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/loans/#{loan}/edit?return_to=show")

      assert render(form_live) =~ "Edit Loan"

      assert form_live
             |> form("#loan-form", loan: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#loan-form", loan: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/loans/#{loan}")

      html = render(show_live)
      assert html =~ "Loan updated successfully"
      assert html =~ "some updated description"
    end
  end
end
