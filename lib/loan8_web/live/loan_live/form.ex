defmodule Loan8Web.LoanLive.Form do
  use Loan8Web, :live_view

  alias Loan8.Finance
  alias Loan8.Finance.Loan

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage loan records in your database.</:subtitle>
      </.header>

      <.form for={@form} id="loan-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:amount]} type="number" label="Amount" />
        <.input field={@form[:interest_rate]} type="number" label="Interest rate" step="any" />
        <.input field={@form[:months]} type="number" label="Months" />
        <.input field={@form[:description]} type="text" label="Description" />
        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Save Loan</.button>
          <.button navigate={return_path(@return_to, @loan)}>Cancel</.button>
        </footer>
      </.form>
    </Layouts.app>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  defp apply_action(socket, :edit, %{"id" => id}) do
    loan = Finance.get_loan!(id)

    socket
    |> assign(:page_title, "Edit Loan")
    |> assign(:loan, loan)
    |> assign(:form, to_form(Finance.change_loan(loan)))
  end

  defp apply_action(socket, :new, _params) do
    loan = %Loan{}

    socket
    |> assign(:page_title, "New Loan")
    |> assign(:loan, loan)
    |> assign(:form, to_form(Finance.change_loan(loan)))
  end

  @impl true
  def handle_event("validate", %{"loan" => loan_params}, socket) do
    changeset = Finance.change_loan(socket.assigns.loan, loan_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"loan" => loan_params}, socket) do
    save_loan(socket, socket.assigns.live_action, loan_params)
  end

  defp save_loan(socket, :edit, loan_params) do
    case Finance.update_loan(socket.assigns.loan, loan_params) do
      {:ok, loan} ->
        {:noreply,
         socket
         |> put_flash(:info, "Loan updated successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, loan))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_loan(socket, :new, loan_params) do
    case Finance.create_loan(loan_params) do
      {:ok, loan} ->
        {:noreply,
         socket
         |> put_flash(:info, "Loan created successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, loan))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path("index", _loan), do: ~p"/loans"
  defp return_path("show", loan), do: ~p"/loans/#{loan}"
end
