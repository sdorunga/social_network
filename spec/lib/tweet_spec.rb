require "./lib/tweet"

RSpec.describe Tweet do
  subject(:tweet) { Tweet.new(id: 1, user_id: user_id, timer: timer, status: "Hola") }
  let(:user_id) { double }
  let(:timer)  { class_double(Time, now: time) }
  let(:time)   { double }

  it "can describe itself" do
    expect(tweet.user_id).to eq(user_id)
    expect(tweet.id).to eq(1)
    expect(tweet.status).to eq("Hola")
    expect(tweet.created_at).to eq(time)
  end
end
