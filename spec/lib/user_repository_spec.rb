require "./lib/user"
require "./lib/user_repository"

RSpec.describe UserRepository do
  subject(:user_repository) { UserRepository.new(user_factory: user_factory) }
  let(:user_factory) { double(User, new: nil) }
  let(:user)  { instance_double(User, name: "Joe") }
  let(:user2)  { instance_double(User, name: "Bob") }

  before do
    allow(user_factory).to receive(:new).with(id: 1, name: "Joe").and_return(user)
    allow(user_factory).to receive(:new).with(id: 2, name: "Bob").and_return(user2)
  end

  it "create a user by name" do
    expect(user_repository.find_or_create_by_name("Joe")).to eq(user)
  end

  it "retrieves a user by name if already exists" do
    user_repository.find_or_create_by_name("Joe")

    expect(user_repository.find_or_create_by_name("Joe")).to eq(user)
  end

  it "creates a second user with an incremented id if it doesn't exist" do
    user_repository.find_or_create_by_name("Joe")

    expect(user_repository.find_or_create_by_name("Bob")).to eq(user2)
  end

  it "can find a user that's been previously created" do
    user_repository.find_or_create_by_name("Joe")

    expect(user_repository.find_by_name("Joe")).to eq(user)
  end

  it "can list all the existing users" do
    user_repository.find_or_create_by_name("Joe")
    user_repository.find_or_create_by_name("Bob")

    expect(user_repository.user_list).to eq("Joe\nBob")
  end
end
