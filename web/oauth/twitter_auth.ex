defmodule TwitterAuth do

  # Public API
  def authorize_url! do
    # Request twitter for a new token
    token = ExTwitter.request_token("http://localhost:4000/auth/twitter/callback")

    # Generate the url for "Sign-in with twitter".
    {:ok, authenticate_url} = ExTwitter.authenticate_url(token.oauth_token)

    authenticate_url 
  end

  def get_handle(token, verifier) do

  # Exchange for an access token
  {:ok, access_token} = ExTwitter.access_token(verifier, token)


  # Configure ExTwitter to use your newly obtained access token
  ExTwitter.configure(
    consumer_key: Application.get_env(:extwitter, :oauth)[:consumer_key],
    consumer_secret: Application.get_env(:extwitter, :oauth)[:consumer_secret],
    access_token: access_token.oauth_token,
    access_token_secret: access_token.oauth_token_secret
  )

  ExTwitter.verify_credentials.screen_name
    
  end


end