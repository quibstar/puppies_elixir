defmodule PuppiesWeb.Router do
  use PuppiesWeb, :router

  import PuppiesWeb.UserAuth

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, {PuppiesWeb.LayoutView, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(:fetch_current_user)
  end

  pipeline(:session_layout) do
    plug(:put_root_layout, {PuppiesWeb.LayoutView, :session})
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  # scope "/", PuppiesWeb do
  #   pipe_through(:browser)

  #   get("/", PageController, :index)
  #   live("/search", SearchLive)
  #   live("/business/:slug", BusinessPageLive)
  # end

  # Other scopes may use custom stacks.
  # scope "/api", PuppiesWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through(:browser)

      live_dashboard("/dashboard", metrics: PuppiesWeb.Telemetry)
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through(:browser)

      forward("/mailbox", Plug.Swoosh.MailboxPreview)
    end
  end

  ## Authentication routes

  scope "/", PuppiesWeb do
    pipe_through([:browser, :session_layout, :redirect_if_user_is_authenticated])
    get("/users/register", UserRegistrationController, :new)
    post("/users/register", UserRegistrationController, :create)
    get("/users/log_in", UserSessionController, :new)
    post("/users/log_in", UserSessionController, :create)
    get("/users/reset_password", UserResetPasswordController, :new)
    post("/users/reset_password", UserResetPasswordController, :create)
    get("/users/reset_password/:token", UserResetPasswordController, :edit)
    put("/users/reset_password/:token", UserResetPasswordController, :update)
  end

  scope "/", PuppiesWeb do
    pipe_through([:browser, :require_authenticated_user])

    # dashboard
    live("/users/dashboard", UserDashboardLive)

    # business
    live("/users/business/new", BusinessNew)
    live("/users/business/:id/edit", BusinessEdit)

    # listings
    live("/listings/new", ListingsNew)
    live("/listings/:listing_id/status", ListingsStatusUpdateForm)
    live("/listings/:listing_id/edit", ListingsEdit)

    # reviews
    get("/reviews/new", ReviewController, :new)
    post("/reviews/create", ReviewController, :create)
    get("/reviews/show/:id", ReviewController, :show)

    # user
    live("/users/profile", UserProfile)
    get("/users/security", UserSecurityController, :edit)
    put("/users/security", UserSecurityController, :update)
    get("/users/settings", UserSettingsController, :edit)
    post("/users/settings", UserSettingsController, :create)
    put("/users/settings", UserSettingsController, :update)
    get("/users/settings/confirm_email/:token", UserSettingsController, :confirm_email)

    # messages
    live("/messages", MessagesLive)

    # notifications
    live("/notifications", NotificationsLive)

    # plans
    live("/plans", ProductsLive)
    live("/checkout/:product", CheckoutLive)
    live("/success", CheckoutSuccessLive)

    # orders
    live("/order-history", OrderHistoryLive)
    live("/id-verification", IDVerificationLive)
  end

  scope "/", PuppiesWeb do
    pipe_through([:browser])

    get("/", PageController, :index)

    live("/search", SearchLive)
    live("/business/:slug", BusinessPageLive)

    # breeds
    live("/breeds", BreedsIndexLive)
    live("/breeds/:slug", BreedsShowLive)
    live("/match-maker", BreedsMatchMakerLive)

    # listings
    live("/listings/:listing_id", ListingShow)

    delete("/users/log_out", UserSessionController, :delete)
    get("/users/confirm", UserConfirmationController, :new)
    post("/users/confirm", UserConfirmationController, :create)
    get("/users/confirm/:token", UserConfirmationController, :edit)
    post("/users/confirm/:token", UserConfirmationController, :update)

    get("/suspended", SuspendedController, :index)
    get("/email-not-confirmed", EmailNotConfirmedController, :index)
    get("/legal/term-of-service", LegalController, :terms_of_service)
    get("/legal/privacy", LegalController, :privacy)
    get("/contacts/new", ContactController, :new)
    post("/contacts", ContactController, :create)
    get("/faq", FaqController, :index)
    get("/sitemap.xml", SitemapController, :index)

    live("/puppies-in/:city/:state/:breed", FindPuppyLive)
    live("/puppies-in/:city/:state", FindPuppyLive)
    live("/puppies-in/:state", FindPuppyLive)
  end

  # webhooks
  scope "/stripe/webhooks", PuppiesWeb do
    post("/", StripeWebhooksController, :webhooks)
  end
end
