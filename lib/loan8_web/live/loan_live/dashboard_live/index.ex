defmodule Loan8Web.DashboardLive.Index do
  use Loan8Web, :live_view

  @impl true
  def mount(_params, _session, socket) do

    calculations = [
      %{
        id: 1,
        name: "Boda boda upgrade",
        principal: "KES 180,000",
        monthly: "KES 8,558",
        months: "24 months",
        rate: "13.0%",
        created: "8 May 2026"
      },

      %{
        id: 2,
        name: "School fees — Term 2",
        principal: "KES 75,000",
        monthly: "KES 12,941",
        months: "6 months",
        rate: "12.0%",
        created: "22 Apr 2026"
      },

      %{
        id: 3,
        name: "Shop stock top-up",
        principal: "KES 320,000",
        monthly: "KES 19,813",
        months: "18 months",
        rate: "14.0%",
        created: "11 Apr 2026"
      },

      %{
        id: 4,
        name: "Emergency — hospital",
        principal: "KES 45,000",
        monthly: "KES 5,232",
        months: "9 months",
        rate: "11.0%",
        created: "30 Mar 2026"
      },

      %{
        id: 5,
        name: "Plot deposit",
        principal: "KES 600,000",
        monthly: "KES 20,507",
        months: "36 months",
        rate: "14.0%",
        created: "14 Feb 2026"
      }
    ]

    {:ok,
      socket
      |> assign(:page_title, "Dashboard")
      |> assign(:calculations, calculations)
      |> assign(:total_saved, length(calculations))
      |> assign(:total_principal, "KES 1,220,000")
      |> assign(:avg_rate, "12.8%")
    }
  end
end
