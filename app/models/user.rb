class User < ActiveRecord::Base

  has_many :questions
  has_many :votes
  has_many :responses
  has_many :answers

  include BCrypt

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end

  def self.authenticate(user_name, password)
    user = User.find_by(user_name: user_name)
    if user
      if user.password == password
        return user
      else
        return nil
      end
    end
    return user
  end

end
