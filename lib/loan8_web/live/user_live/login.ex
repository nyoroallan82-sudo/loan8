defmodule Loan8Web.UserLive.Login do
  use Loan8Web, :live_view

  alias Loan8.Accounts

@impl true
def render(assigns) do
  ~H"""
  <div class="min-h-screen bg-slate-50 text-slate-800">


    <header class="bg-white border-b border-slate-200">
      <div class="max-w-7xl mx-auto px-8 py-4 flex items-center justify-between">


        <div class="flex items-center gap-10">

          <div class="flex items-center gap-3">
            <div class="w-9 h-9 rounded-lg bg-green-600 flex items-center justify-center text-white font-bold">
              L8
            </div>
            <span class="font-bold text-xl">Loan8</span>
          </div>

          <nav class="hidden md:flex items-center gap-8 text-slate-600">
            <.link navigate={~p"/"} class="hover:text-green-600">Home</.link>
            <a href="#" class="hover:text-green-600">How it works</a>
            <a href="#" class="hover:text-green-600">For Saccos</a>
            <a href="#" class="hover:text-green-600">FAQ</a>
          </nav>

        </div>


        <div class="flex items-center gap-6">
          <.link navigate={~p"/users/log-in"} class="text-slate-700 hover:text-green-600">
            Log in
          </.link>

          <.link
            navigate={~p"/users/register"}
            class="bg-green-600 hover:bg-green-700 text-white px-5 py-2.5 rounded-xl font-semibold"
          >
            Create free account
          </.link>

          <.link navigate={~p"/"} class=" text-slate-500  hover:text-green-600 ">
          Dashboard
        </.link>

        <.link navigate={~p"/calculator"} class="text-slate-500 hover:text-green-600">
          Calculator
        </.link>
        </div>

      </div>
    </header>


    <main class="flex items-center justify-center px-6 py-20">

      <div class="w-full max-w-md bg-white border border-slate-200 rounded-2xl shadow-sm p-10">


        <div class="mb-8 text-center">
          <h1 class="text-3xl font-bold">Log in to Loan8</h1>
          <p class="text-slate-500 mt-2">
            Welcome back. Enter your details below.
          </p>
        </div>


        <.form
          :let={f}
          for={@form}
          id="login_form_password"
          phx-submit="submit_password"
          class="space-y-5"
        >


          <div>
            <label class="block text-sm font-medium mb-2">Email</label>
            <input
              type="email"
              name={f[:email].name}
              value={f[:email].value}
              class="w-full rounded-xl border border-slate-300 px-4 py-3 focus:ring-2 focus:ring-green-600 focus:outline-none"
              placeholder="you@example.com"
              required
            />
          </div>


          <div>
            <div class="flex justify-between items-center mb-2">
              <label class="block text-sm font-medium">Password</label>
              <a href="#" class="text-sm text-green-600 hover:underline">Forgot?</a>
            </div>

            <input
              type="password"
              name={f[:password].name}
              value={f[:password].value}
              class="w-full rounded-xl border border-slate-300 px-4 py-3 focus:ring-2 focus:ring-green-600 focus:outline-none"
              required
            />
          </div>


          <button
            type="submit"
            class="w-full bg-green-600 hover:bg-green-700 text-white py-3 rounded-xl font-semibold text-lg transition"
          >
            Log in
          </button>

        </.form>


        <div class="mt-8 text-center text-sm text-slate-500">
          New to Loan8?
          <.link navigate={~p"/users/register"} class="text-green-600 font-semibold hover:underline">
            Create an account
          </.link>
        </div>

        <p class="mt-6 text-center text-xs text-slate-400">
          Demo: any email + password will sign you in.
        </p>

      </div>
    </main>

  </div>
  """
end

  @impl true
  def mount(_params, _session, socket) do
    email =
      Phoenix.Flash.get(socket.assigns.flash, :email) ||
        get_in(socket.assigns, [:current_scope, Access.key(:user), Access.key(:email)])

    form = to_form(%{"email" => email}, as: "user")

    {:ok, assign(socket, form: form, trigger_submit: false)}
  end

  @impl true
  def handle_event("submit_password", _params, socket) do
    {:noreply, assign(socket, :trigger_submit, true)}
  end

  def handle_event("submit_magic", %{"user" => %{"email" => email}}, socket) do
    if user = Accounts.get_user_by_email(email) do
      Accounts.deliver_login_instructions(
        user,
        &url(~p"/users/log-in/#{&1}")
      )
    end

    info =
      "If your email is in our system, you will receive instructions for logging in shortly."

    {:noreply,
     socket
     |> put_flash(:info, info)
     |> push_navigate(to: ~p"/users/log-in")}
  end

  defp local_mail_adapter? do
    Application.get_env(:loan8, Loan8.Mailer)[:adapter] == Swoosh.Adapters.Local
  end
end
