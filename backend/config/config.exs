# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :cosif,
  ecto_repos: [Cosif.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configure the endpoint
config :cosif, CosifWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [json: CosifWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Cosif.PubSub,
  live_view: [signing_salt: "0J3RAiHf"]

# Configure Elixir's Logger
config :logger, :default_formatter,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
