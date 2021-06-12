class TwitterClient
  attr_reader :client

  def initialize
    nil unless valid?
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key = ENV['TWITTER_API_KEY']
      config.consumer_secret = ENV['TWITTER_API_SECRET_KEY']
      config.access_token = ENV['TWITTER_ACCESS_TOKEN']
      config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
    end
  end

  def tweet(str)
    nil unless @client.credentials?
    @client.update(str)
  end

  private

  def valid?
    ENV['TWITTER_API_KEY'] &&
      ENV['TWITTER_API_SECRET_KEY'] &&
      ENV['TWITTER_ACCESS_TOKEN'] &&
      ENV['TWITTER_ACCESS_TOKEN_SECRET']
  end
end
