require 'time'

class Tweet
  attr_reader :user_id, :id, :created_at, :status

  def initialize(id:, user_id:, status:, timer: Time)
    @user_id = user_id
    @id = id
    @created_at = timer.now
    @status = status
  end

  def to_s
    "#{@status}\n- #{@created_at}"
  end
end
