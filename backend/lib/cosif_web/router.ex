defmodule CosifWeb.Router do
  use CosifWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/v1", CosifWeb do
    pipe_through :api

    get "/accounts/search", AccountController, :search
    get "/accounts/:code", AccountController, :show
    get "/accounts/:code/children", AccountController, :children
    get "/accounts/:code/ancestry", AccountController, :ancestry

    get "/functions/search", FunctionController, :search
    get "/functions/:code", FunctionController, :show
  end

  # Enable LiveDashboard in development
  if Application.compile_env(:cosif, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: CosifWeb.Telemetry
    end
  end
end
