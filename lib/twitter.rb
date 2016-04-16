require './lib/tweet.rb'
require './lib/tweet_repository.rb'
require './lib/user.rb'
require './lib/user_repository.rb'
require 'pry'

class Twitter
  def initialize
    @users_repo = UserRepository.instance
  end

  def get_user(username)
    @user = @users_repo.find_or_create_by_name(username)
  end

  def tweet(tweet)
    @user.tweet(tweet)
  end

  def follow(username)
    to_follow = @users_repo.find_by_name(username)
    @user.follow(to_follow)
  end

  def list_users
    puts "These are the available users:"
    puts @users_repo.user_list
  end

  def timeline
    puts @user.timeline
  end
end

class Commands
  def initialize(subject)
    @subject = subject
    @commands = {}
  end

  def setup(command, dependent_commands=[], message=nil)
    @setup = {command: command, dependent_commands: dependent_commands, message: message}
    self
  end

  def register(name, command, dependent_commands=[], message=nil)
    @commands[name] = {command: command, dependent_commands: dependent_commands, message: message}
    self
  end

  def stop(command)
    @stop_command = command
    self
  end
  
  def default(text)
    @default = text
    self
  end

  def run
    run_command(@setup)
    loop do
      list_commands
      command = gets().chomp

      break if command == @stop_command
      next (puts @default) unless @commands[command]

      run_command(@commands[command])
    end
  end

  private

  def run_command(command)
    command[:dependent_commands].each { |name| @commands[name][:command].call(@subject) }
    if command[:message]
      puts command[:message]
      response = gets().chomp
      command[:command].call(@subject, response) 
    else
      command[:command].call(@subject) 
    end
  end

  def list_commands
    puts "You can do the following commands: #{@commands.keys.join(", ")}"
    puts "What would you like to do?"
  end

  class Command
    attr_reader :name
    def initialize(name, command, dependencies, prompt)
      @name = name
      @command = command
      @dependencies = dependencies
      @prompt = prompt
    end

    def run(subject)
      if @prompt
        puts @prompt
        response = gets().chomp
        @command.call(subject, response)
      else
        @command.call(subject)
      end
    end
  end
end

Commands.new(Twitter.new)
.setup(->(me, arg){me.get_user(arg)}, [], "What is your username?")
.register("tweet", ->(me, arg){me.tweet(arg)}, [], "What's on your mind?")
.register("timeline", ->(me){me.timeline})
.register("follow", ->(me, arg){me.follow(arg)}, ["list users"], "Which one do you want to follow?")
.register("list users", ->(me){me.list_users})
.register("sign out", ->(me, arg){me.get_user(arg)}, [], "What is your username?")
.stop("quit")
.default("Sorry I only understand the specified commands, try again!")
.run

