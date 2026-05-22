defmodule Loan8Web.LoanLive.Index do
  use Loan8Web, :live_view

  @impl true
  def mount(_params, _session, socket) do
    amount = 50_000
    rate = 13.1
    months = 12

    calculations = calculate(amount, rate, months)

    {:ok,
     socket
     |> assign(:amount, amount)
     |> assign(:rate, rate)
     |> assign(:months, months)
     |> assign(:description, "")
     |> assign(:calculations, calculations)}
  end

  @impl true
  def handle_event("update", params, socket) do
    amount = parse_int(params["amount"])
    rate = parse_float(params["rate"])
    months = parse_int(params["months"])
    description = params["description"] || ""

    calculations = calculate(amount, rate, months)

    {:noreply,
     socket
     |> assign(:amount, amount)
     |> assign(:rate, rate)
     |> assign(:months, months)
     |> assign(:description, description)
     |> assign(:calculations, calculations)}
  end

  defp parse_int(nil), do: 0
  defp parse_int(""), do: 0

  defp parse_int(value) when is_integer(value), do: value

  defp parse_int(value) do
    value
    |> String.replace(",", "")
    |> String.to_integer()
  end

  defp parse_float(nil), do: 0.0
defp parse_float(""), do: 0.0

  defp parse_float(value) when is_float(value), do: value

  defp parse_float(value) do
    String.to_float(value)
  end

  defp calculate(amount, annual_rate, months) do
    monthly_rate = annual_rate / 100 / 12

    payment =
      if monthly_rate == 0 do
        amount / months
      else
        amount *
          (monthly_rate * :math.pow(1 + monthly_rate, months)) /
          (:math.pow(1 + monthly_rate, months) - 1)
      end

    total_payment = payment * months
    total_interest = total_payment - amount

    schedule = amortization_schedule(amount, monthly_rate, payment, months)

    %{
      monthly_payment: Float.round(payment, 0),
      total_payment: Float.round(total_payment, 0),
      total_interest: Float.round(total_interest, 0),
      ratio: Float.round(total_payment / amount, 2),
      principal_percent: Float.round(amount / total_payment * 100, 1),
      interest_percent: Float.round(total_interest / total_payment * 100, 1),
      schedule: schedule
    }
 end

  defp amortization_schedule(balance, rate, payment, months) do
    Enum.map(1..months, fn month ->
      interest = balance * rate
      principal = payment - interest
      new_balance = max(balance - principal, 0)

      row = %{
        month: month,
        payment: Float.round(payment, 2),
        principal: Float.round(principal, 2),
        interest: Float.round(interest, 2),
        balance: Float.round(new_balance, 2)
      }




      row
    end)
  end
end
