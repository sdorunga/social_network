class User
  attr_reader :name, :id
  def initialize(id:, name:, tweet_repository: TweetRepository.instance)
    @id = id
    @name = name
    @tweet_repository = tweet_repository
    @followings = []
  end

  def tweet(status)
    @tweet_repository.add_tweet(status: status, user_id: self.id)
  end

  def timeline
    @tweet_repository.tweets_for([self.id] + @followings)
  end

  def follow(user)
    @followings << user.id
  end
end
