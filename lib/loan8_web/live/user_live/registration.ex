defmodule Loan8Web.UserLive.Registration do
  use Loan8Web, :live_view

  alias Loan8.Accounts
  alias Loan8.Accounts.User

  @impl true
  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-[#f3f5f7]">


      <header class="bg-white border-b border-slate-200">
        <div class="max-w-7xl mx-auto px-8 h-12 flex items-center justify-between">


          <div class="flex items-center gap-12">


            <div class="flex items-center gap-3">
              <div class="w-8 h-8 rounded-lg bg-green-600 flex items-center justify-center text-white font-bold text-sm">
                L8
              </div>

              <span class="text-2xl font-bold text-slate-900">
                Loan8
              </span>
            </div>


            <nav class="hidden md:flex items-center gap-10 text-[17px]">
              <.link navigate={~p"/"} class="text-slate-700 hover:text-green-600">Home</.link>
              <.link navigate={~p"/how-it-works"} class="text-slate-700 hover:text-green-600">How it works</.link>
              <.link navigate={~p"/for-saccos"} class="text-slate-700 hover:text-green-600">For Saccos</.link>
              <.link navigate={~p"/faq"} class="text-slate-700 hover:text-green-600">FAQ</.link>
            </nav>
          </div>


          <div class="flex items-center gap-8">
            <.link navigate={~p"/users/log-in"} class="text-slate-800 font-semibold hover:text-green-600">
              Log in
            </.link>

            <.link
              navigate={~p"/users/register"}
              class="bg-green-600 hover:bg-green-700 text-white px-6 py-2.5 rounded-xl font-semibold transition"
            >
              Create free account
            </.link>
          </div>
        </div>
      </header>


      <div class="min-h-[calc(100vh-3rem)] flex items-center justify-center px-4 py-6">


        <div class="w-full max-w-md bg-white rounded-2xl border border-slate-200 p-6 shadow-sm">


          <div class="mb-6">
            <h1 class="text-3xl font-bold text-slate-900 leading-tight">
              Create your free account
            </h1>

            <p class="mt-2 text-base text-slate-500">
              Takes about 30 seconds. No card needed.
            </p>
          </div>


          <.form
            for={@form}
            id="registration_form"
            phx-submit="save"
            phx-change="validate"
            class="space-y-4"
          >


            <div>
              <label class="block text-sm  font-medium text-slate-900 mb-1.5">
                Full name
              </label>

              <input
                type="text"
                name="user[name]"
                placeholder="e.g. Wanjiku Otieno"
                class="w-full h-11 rounded-xl border border-slate-300 px-4  text-base text-slate-800 outline-none focus:ring-2 focus:ring-green-500"
              />
            </div>


            <div>
              <label class="block text-sm font-medium text-slate-900 mb-1.5">
                Email
              </label>

              <input
                type="email"
                name="user[email]"
                placeholder="you@example.com"
                class="w-full h-11 rounded-xl border border-slate-300 px-4 text-base text-slate-800 outline-none focus:ring-2 focus:ring-green-500"
              />
            </div>


            <div>
              <label class="block text-sm font-medium text-slate-900 mb-1.5">
                Password
              </label>

              <input
                type="password"
                name="user[password]"
                placeholder="At least 6 characters"
                class="w-full h-11 rounded-xl border border-slate-300 px-4 text-base text-slate-800 outline-none focus:ring-2 focus:ring-green-500"
              />
            </div>


            <div>
              <label class="block text-sm font-medium text-slate-900 mb-1.5">
                Confirm password
              </label>

              <input
                type="password"
                name="user[password_confirmation]"
                placeholder="Re-enter password"
                class="w-full h-11 rounded-xl border border-slate-300 px-4 text-base text-slate-800 outline-none focus:ring-2 focus:ring-green-500"
              />
            </div>


            <button
              type="submit"
              class="w-full h-11 rounded-xl bg-green-600 hover:bg-green-700 text-white text-base font-semibold transition"
            >
              Create account
            </button>
          </.form>


          <p class="text-center text-slate-500 text-sm mt-5 leading-relaxed">
            By creating an account you agree to our
            <a href="#" class="underline hover:text-green-600">Terms</a>
            and
            <a href="#" class="underline hover:text-green-600">Privacy Policy.</a>
          </p>


          <div class="border-t border-slate-200 my-6"></div>


          <p class="text-center text-slate-600 text-base">
            Already have an account?
            <.link navigate={~p"/users/log-in"} class="text-green-600 font-semibold hover:text-green-700">
              Log in
            </.link>
          </p>

        </div>
      </div>
    </div>
    """
  end

  @impl true
  def mount(_params, _session, %{assigns: %{current_scope: %{user: user}}} = socket)
      when not is_nil(user) do
    {:ok, redirect(socket, to: Loan8Web.UserAuth.signed_in_path(socket))}
  end

  def mount(_params, _session, socket) do
    changeset = Accounts.change_user_email(%User{}, %{}, validate_unique: false)
    {:ok, assign_form(socket, changeset), temporary_assigns: [form: nil]}
  end

  @impl true
  def handle_event("save", %{"user" => user_params}, socket) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_login_instructions(
            user,
            &url(~p"/users/log-in/#{&1}")
          )

        {:noreply,
         socket
         |> put_flash(:info, "An email was sent to #{user.email}, please access it to confirm your account.")
         |> push_navigate(to: ~p"/users/log-in")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Accounts.change_user_email(%User{}, user_params, validate_unique: false)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "user")
    assign(socket, form: form)
  end
end
