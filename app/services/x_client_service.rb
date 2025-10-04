# app/services/x_client_service.rb

class XClientService
  def initialize
    # 1. Load credentials from the Rails encrypted store
    x_credentials = Rails.application.credentials.x_api

    # 2. Check if credentials are set (optional, but recommended)
    unless x_credentials[:api_key] && x_credentials[:api_key_secret]
      raise "X API credentials not configured in Rails credentials."
    end

    # 3. Initialize the X::Client
    @client = X::Client.new(
      api_key: x_credentials[:api_key],
      api_key_secret: x_credentials[:api_key_secret],
      access_token: x_credentials[:access_token],
      access_token_secret: x_credentials[:access_token_secret]
    )
  end

  # Example method: Fetch user data
  # API endpoint: GET /2/users/me
  def get_my_user_data
    # Use the client to make a GET request to the 'users/me' endpoint
    @client.get("users/me")
  rescue X::Error => e
    # Handle API errors gracefully
    Rails.logger.error("X API Error: #{e.message}")
    nil
  end

  # Example method: Post a new tweet (requires write permissions)
  # API endpoint: POST /2/tweets
  def post_new_tweet(text)
    payload = { text: text }.to_json
    @client.post("tweets", payload)
  rescue X::Error => e
    Rails.logger.error("X API Error: #{e.message}")
    nil
  end

  def delete_tweet(tweet_id)
    @client.delete("tweets/#{tweet_id}")
  rescue X::Error => e
    Rails.logger.error("X API Error: #{e.message}")
    nil
  end

  def list_tweets(x_user_id = "me")
    @client.get("users/#{x_user_id}/tweets")
  rescue X::Error => e
    Rails.logger.error("X API Error: #{e.message}")
    nil
  end

end
