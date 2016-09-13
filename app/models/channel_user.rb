class ChannelUser < ActiveRecord::Base
  has_secure_password

  validates :email,:phone, uniqueness: true
  before_create :set_token


  private
  def set_token
    loop do
      self.token = User.gen_token
      break if User.where(token: token).empty?
    end
  end

  def self.gen_token
    SecureRandom.urlsafe_base64
  end
end
