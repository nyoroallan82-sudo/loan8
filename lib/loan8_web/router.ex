defmodule Loan8Web.Router do
  use Loan8Web, :router
  import Loan8Web.UserAuth
  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {Loan8Web.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers

    plug :fetch_current_scope_for_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Loan8Web do
    pipe_through :browser

    live "/", DashboardLive.Index, :index
    live "/dashboard", DashboardLive.Index, :index

    live "/calculator", LoanLive.Index, :index

  end

scope "/", Loan8Web do
  pipe_through [:browser]

  live_session :redirect_if_user_is_authenticated,
    on_mount: [{Loan8Web.UserAuth, :mount_current_scope}] do

    live "/users/register", UserLive.Registration, :new
    live "/users/log-in", UserLive.Login, :new
    live "/users/reset-password", UserLive.ForgotPassword, :new
    live "/users/reset-password/:token", UserLive.ResetPassword, :edit
  end

  live_session :require_authenticated_user,
    on_mount: [{Loan8Web.UserAuth, :require_authenticated}] do

    live "/users/settings", UserLive.Settings, :edit
    live "/users/settings/confirm-email/:token", UserLive.Settings, :confirm_email
  end

  live_session :current_user,
    on_mount: [{Loan8Web.UserAuth, :mount_current_user}] do

    live "/users/confirm/:token", UserLive.Confirmation, :edit
    live "/users/confirm", UserLive.ConfirmationInstructions, :new
  end

  post "/users/log-in", UserSessionController, :create
  delete "/users/log-out", UserSessionController, :delete
end

  # Other scopes may use custom stacks.
  # scope "/api", Loan8Web do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:loan8, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: Loan8Web.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
