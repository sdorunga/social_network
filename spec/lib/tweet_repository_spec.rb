require "./lib/tweet"
require "./lib/tweet_repository"

RSpec.describe TweetRepository do
  subject(:user) { TweetRepository.new(tweet_factory: tweet_factory) }
  let(:tweet_factory) { double(Tweet, new: nil) }
  let(:tweet)  { instance_double(Tweet, user_id: 1) }
  let(:second_tweet)  { instance_double(Tweet, user_id: 2) }

  it "can store tweets for a user" do
    allow(tweet_factory).to receive(:new).with(id: 1, status: "Hello", user_id: 1).and_return(tweet)
    subject.add_tweet(status: "Hello", user_id: 1)

    expect(subject.tweets_for([1])).to eq([tweet])
  end

  it "can store tweets for multiple users and return individual users tweets" do
    allow(tweet_factory).to receive(:new).with(id: 1, status: "Hello", user_id: 1).and_return(tweet)
    allow(tweet_factory).to receive(:new).with(id: 2, status: "Hello Second", user_id: 2).and_return(second_tweet)
    subject.add_tweet(status: "Hello", user_id: 1)
    subject.add_tweet(status: "Hello Second", user_id: 2)

    expect(subject.tweets_for([1])).to eq([tweet])
  end

  it "can store tweets for multiple users and return multiple users tweets" do
    allow(tweet_factory).to receive(:new).with(id: 1, status: "Hello", user_id: 1).and_return(tweet)
    allow(tweet_factory).to receive(:new).with(id: 2, status: "Hello Second", user_id: 2).and_return(second_tweet)
    subject.add_tweet(status: "Hello", user_id: 1)
    subject.add_tweet(status: "Hello Second", user_id: 2)

    expect(subject.tweets_for([1, 2])).to eq([tweet, second_tweet])
  end
end
