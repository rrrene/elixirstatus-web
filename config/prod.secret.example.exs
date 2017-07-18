use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
config :elixir_status, ElixirStatus.Endpoint,
  secret_key_base: "secret"

# Configure your database
config :elixir_status, ElixirStatus.Repo,
  adapter: Ecto.Adapters.MySQL,
  username: "secret",
  password: "secret",
  database: "elixir_status_prod",
  size: 20 # The amount of database connections in the pool

config :extwitter, :oauth, [
   consumer_key: "secret",
   consumer_secret: "secret",
   access_token: "secret",
   access_token_secret: "secret"
]

config :appsignal, :config,
  name: :elixir_status,
  push_api_key: "your-hex-appsignal-key",
  env: :prod,
  revision: Mix.Project.config[:version]
