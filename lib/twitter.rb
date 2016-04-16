require './lib/tweet.rb'
require './lib/tweet_repository.rb'
require './lib/user.rb'
require './lib/user_repository.rb'
require 'pry'

class Twitter
  def initialize
    @users_repo = UserRepository.instance
  end

  def main
    puts "Hello, what is your username?"
    username = gets().chomp
    user = @users_repo.find_or_create_by_name(username)
    loop_for_user(user)
  end

  def loop_for_user(user)
    loop do
      puts "What would you like to do?"
      puts "You can `tweet`, `follow` a user, check your `timeline`, and `sign out`"
      action = gets().chomp
      case action
      when "tweet"
        puts "What's on your mind"
        tweet = gets().chomp
        user.tweet(tweet)
      when "follow"
        puts "These are the available users:"
        puts @users_repo.user_list
        puts "Which one do you want to follow?"
        username = gets().chomp
        to_follow = @users_repo.find_by_name(username)
        user.follow(to_follow)
      when "timeline"
        puts user.timeline
      when "sign out"
        main
      else "Sorry I only understand the specified commands, try again!"
      end
    end
  end
end

Twitter.new.main
