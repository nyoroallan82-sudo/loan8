defmodule Loan8Web.LoanLive.Show do
  use Loan8Web, :live_view

  alias Loan8.Finance

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Loan {@loan.id}
        <:subtitle>This is a loan record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/loans"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/loans/#{@loan}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit loan
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Amount">{@loan.amount}</:item>
        <:item title="Interest rate">{@loan.interest_rate}</:item>
        <:item title="Months">{@loan.months}</:item>
        <:item title="Description">{@loan.description}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Show Loan")
     |> assign(:loan, Finance.get_loan!(id))}
  end
end
