use Mix.Config

config :extwitter, :oauth,
  consumer_key: "",
  consumer_secret: "",
  access_token: "",
  access_token_secret: ""

config :elixir_status, :twitter_oauth_for_handle_verification,
  consumer_key: "",
  consumer_secret: "",
  access_token: " ",
  access_token_secret: ""

# This function receives the posting and author as arguments and determines
# reasons why it requires moderation
# Return an empty list if no moderation is necessary
config :elixir_status,
       :publisher_moderation_reasons,
       &ElixirStatusModerationSample.moderation_reasons/2
