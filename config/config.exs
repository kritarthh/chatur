# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :chatur,
  ecto_repos: [Chatur.Repo]

# Configures the endpoint
config :chatur, ChaturWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "5GOJICXihpICq5tJw68EwG+i2hd6PdT/bSwx3enugRs8edfQdF5502dE0kRBROkE",
  render_errors: [view: ChaturWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Chatur.PubSub,
  live_view: [signing_salt: "flwohEcD"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
