class TweetRepository
  def self.instance
    @@instance ||= self.new
  end

  def initialize(tweet_factory: Tweet)
    @tweet_factory = tweet_factory
    @tweets = []
    @id = 0
  end

  def add_tweet(status:, user_id:)
    @tweet_factory.new(id: generate_id, status: status, user_id: user_id).tap do |tweet|
      @tweets << tweet
    end
  end

  def tweets_for(user_ids)
    @tweets.select {|tweet| user_ids.include? tweet.user_id }
  end

  def generate_id
    @id += 1
  end
end
