require "./lib/user"
require "./lib/tweet_repository"

RSpec.describe User do
  subject(:user) { User.new(id: 1, name: "Horje", tweet_repository: tweet_repository) }
  let(:tweet_repository) { instance_double(TweetRepository, add_tweet: nil, tweets_for: []) }
  let(:status) { "Deez Nutz" }
  let(:timeline_tweets) { double() }

  it "can describe itself" do
    expect(user.id).to eq(1)
    expect(user.name).to eq("Horje")
  end

  it "can tweet" do
    subject.tweet(status)

    expect(tweet_repository).to have_received(:add_tweet).with(status: status, user_id: user.id)
  end

  it "can retreive tweets from its timeline" do
    allow(tweet_repository).to receive(:tweets_for).with([user.id]).and_return(timeline_tweets)

    expect(subject.timeline).to eq(timeline_tweets)
  end

  it "asks for tweets for followed users" do
    subject.follow(User.new(id: 2, name: "Lisa", tweet_repository: tweet_repository))
    allow(tweet_repository).to receive(:tweets_for).with([user.id, 2]).and_return(timeline_tweets)

    expect(subject.timeline).to eq(timeline_tweets)
  end
end
