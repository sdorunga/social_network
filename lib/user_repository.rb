class UserRepository
  def self.instance
    @@instance ||= self.new
  end

  def initialize(user_factory: User)
    @user_factory = user_factory
    @users = []
    @id = 0
  end

  def find_or_create_by_name(name)
    return find_by_name(name) if username_taken?(name)

    @user_factory.new(id: generate_id, name: name).tap do |user|
      @users << user
    end
  end

  def find_by_name(name)
    @users.find { |user| user.name == name }
  end

  def user_list
    @users.map(&:name).join("\n")
  end
  private

  def username_taken?(name)
    @users.any? { |user| user.name == name }
  end

  def generate_id
    @id += 1
  end
end
