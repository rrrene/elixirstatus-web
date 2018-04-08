use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
config :elixir_status, ElixirStatus.Endpoint, secret_key_base: "secret"

# Configure your database
config :elixir_status, ElixirStatus.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "secret",
  password: "secret",
  database: "elixir_status_prod",
  hostname: "localhost",
  pool_size: 10

config :elixir_status, :twitter_oauth_for_handle_verification,
  consumer_key: "",
  consumer_secret: "",
  access_token: " ",
  access_token_secret: ""

config :ex_twitter, :oauth,
  consumer_key: "secret",
  consumer_secret: "secret",
  access_token: "secret",
  access_token_secret: "secret"

config :appsignal, :config,
  name: :elixir_status,
  push_api_key: "your-hex-appsignal-key",
  env: :prod,
  revision: Mix.Project.config()[:version]

# This function receives the posting and author as arguments and determines
# reasons why it requires moderation
# Return an empty list if no moderation is necessary
config :elixir_status,
       :publisher_moderation_reasons,
       &ElixirStatusModerationSample.moderation_reasons/2
