# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :phoenix_00, Phoenix00.Repo, migration_primary_key: [type: :uuid]

config :phoenix_00,
  ecto_repos: [Phoenix00.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :phoenix_00, Phoenix00Web.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: Phoenix00Web.ErrorHTML, json: Phoenix00Web.ErrorJSON],
    layout: false
  ],
  pubsub_server: Phoenix00.PubSub,
  live_view: [signing_salt: "BWJZTt5D"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
# config :phoenix_00, Phoenix00.Mailer, adapter: Swoosh.Adapters.Local

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  phoenix_00: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.4.0",
  phoenix_00: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :phoenix_00, Oban,
  engine: Oban.Engines.Lite,
  queues: [default: 10, mailer: 20],
  repo: Phoenix00.Repo

config :phoenix_00, Phoenix00.Repo,
  adapter: Ecto.Adapters.SQLite3,
  database: "00.sqlite"

config :phoenix_00, sqs_url: System.get_env("SST_RESOURCE_ZeroEmailSQS")
config :flop, repo: Phoenix00.Repo
# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
