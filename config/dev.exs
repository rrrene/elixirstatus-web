use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :elixir_status, ElixirStatus.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  cache_static_lookup: false,
  watchers: [node: ["node_modules/brunch/bin/brunch", "watch",
               cd: Path.expand("../", __DIR__)]]

# Watch static and templates for browser reloading.
config :elixir_status, ElixirStatus.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif)$},
      ~r{web/views/.*(ex)$},
      ~r{web/templates/.*(eex)$}
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Configure your database
config :elixir_status, ElixirStatus.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "elixir_status_dev",
  hostname: "localhost",
  pool_size: 10

config :elixir_status, :base_url, "http://localhost:4000"

config :elixir_status, :twitter_screen_name, "elixirstatus"
config :elixir_status, :twitter_dm_recipient, "elixirstatus"

config :elixir_status, :admin_user_ids, [1]
config :elixir_status, :admin_overview_iframe_url, "http://twitter.com/"
config :elixir_status, :admin_site_switcher_html, ""

# Finally import the config/dev.secret.exs
# which should be versioned separately.
import_config "dev.secret.exs"
